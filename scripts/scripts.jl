using TeoBot
function main()
    @info "Hello, I am starting..."
    
    for i = 1:1000
        TeoBot.post_tweet_from_rss()
        @info "Next tweet in 15 mins."
        sleep(60*15) # 15 minutes
    end
    
    @info "Time to sleep... Bye!"
end

main()

