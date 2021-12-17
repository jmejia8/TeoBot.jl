using EzXML
using Downloads
using TwiliteTimeline
using DelimitedFiles
using Random

function xml2dict_(root_node, data = Dict())
    
    if countnodes(root_node) == 1
        data[nodename(root_node)] = nodecontent(root_node)
        return data
    end
    
    dd = Dict()
    for item in eachelement(root_node)
        d = xml2dict_(item, dd)
    end


    if nodename(root_node) in collect(keys(data))
        data[nodename(root_node)] = vcat(data[nodename(root_node)], dd)
    else
        data[nodename(root_node)] = dd
    end

    return data
end

function xml2dict(root_node)
    d  =xml2dict_(root_node)
    if "rss" ∉ collect(keys(d)) || "channel" ∉ collect(keys(d["rss"]))
        return Dict("item" => [])
    end
    
    return d["rss"]["channel"]
end

const favorites_channels = [
                            Dict("url" => "http://feeds.weblogssl.com/xatakaciencia",
                                 "emojis" => "👩‍🔬🖥👩‍🏫🦾",
                                 "trust"=>true,
                                ),
                            Dict("url" => "https://feedmix.novaclic.com/atom2rss.php?source=https%3A%2F%2Fwww.proceso.com.mx%2Frss%2Ffeed.html%3Fr%3D6",
                                 "emojis" => "👩‍🔬🖥👩‍🏫🦾",
                                 "trust"=>true,
                                ),
                            Dict("url" => "http://feeds.weblogssl.com/genbeta",
                                 "emojis" => "👩‍🔬🖥👩‍🏫🦾",
                                 "trust"=>true,
                                ),
                            Dict("url" => "https://www.hollywoodreporter.com/topic/movies/feed/",
                                 "emojis" => "🎥🎬📽",
                                 "trust"=>true,
                                ),
                            Dict("url" => "https://ieeexplore.ieee.org/rss/TOC4235.XML",
                                 "emojis" => "🧬",
                                 "trust"=>true,
                                ),
                            # Dict("url" => "https://julialang.org/feed.xml",
                            #      "emojis" => "💻",
                            #      "trust"=>false,
                            #     ),
                           ]

function get_tweet_from_rss()
    fname = normpath(joinpath(@__FILE__,"..", "..","data"))
    if !isdir(fname)
        mkdir(fname)
        writedlm(joinpath(fname, "published_tweets.txt"), ["publishedTweets"])
    end
    
    # uri = ""
    channel = rand(favorites_channels)
    uri = channel["url"]

    doc = Downloads.download(uri) |> readxml

    r = root(doc)
    d = xml2dict(r)

    published_tweets = readdlm(joinpath(fname, "published_tweets.txt"))
    txt = ""
    for item in shuffle(d["item"])
        if item["link"] in published_tweets
            continue
        end
        txt *= item["title"] * " " * string(rand(channel["emojis"])) * "\n" * item["link"]

        writedlm(joinpath(fname, "published_tweets.txt"), vcat(published_tweets, item["link"]))
        break
    end

    return txt
end


function post_tweet_from_rss(testing = false)
    creds = Authentictor(ENV["TWITTER_CKEY"], ENV["TWITTER_CSEC"], ENV["TWITTER_OTOK"], ENV["TWITTER_OSEC"])
    txt = get_tweet_from_rss()
    if isempty(txt)
        @warn "No tweet was available for publication."
        return false
    end
    
    @info "Publishing: "*txt
    if !testing
        params = ParamsPostTweet(txt)
        tweet = post_tweet(creds, params)
    end
    
    @info "Done!"
    return true
end

