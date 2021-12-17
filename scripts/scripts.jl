using TeoBot
function main()
    @info "Hello, I am starting..."

    # every freq minues, a tweet will be published
    freq = 45 # minutes
    
    for i = 1:1000 # limiting the number of tweets in Teo life time.
        TeoBot.post_tweet_from_rss()
        @info "Next tweet in $freq minutes."
        sleep(60*freq) # freq minutes
    end
    
    @info "Time to sleep... Bye!"
end

main()

