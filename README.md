# TeoBot

This is a very simple bot to publish random stuff from the internet.


## Usage

Firstly, you need credentials for accessing to the twitter API. [Apply here](https://developer.twitter.com/).

Save those credentials in `ENV` variables ([see documentation](https://docs.julialang.org/en/v1/manual/environment-variables/)).

Required values: `ENV["TWITTER_CKEY"], ENV["TWITTER_CSEC"], ENV["TWITTER_OTOK"], ENV["TWITTER_OSEC"]`.


After that, download TeoBot and `cd` to this project, then in terminal (linux or similar) execute:

```
julia --project=./ --color=yes scripts/scripts.jl
```


In `scripts` you'll find some examples.


