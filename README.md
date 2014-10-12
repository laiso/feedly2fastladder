# Feedly2fastladder

Bridge for converting to the Web API response of Fast ladder (https://github.com/fastladder/fastladder) from Feedly cloud.

First get your access token of Feedly API sandbox.

* http://developer.feedly.com/v3/sandbox/

## Integrate with Fastladder

You must use Fastladder + Feedly backend fork version.
https://github.com/laiso/fastladder/tree/feedly_backend

## Subscriptions

```ruby:
f2f = Feedly2fastladder.new(token: ENV["FEEDLY_TOKEN"])

json_body = f2f.subs(unread: false)
puts json_body
```

```ruby:
feeds = JSON.parse(json_body)
feeds.each do |feed|
	puts feed["title"]
end
```

## Articles

```ruby:
json_body = f2f.unread subscribe_id: 'feed/http://blogs.jetbrains.com/ruby/feed/'
puts json_body
```

## Mark as Read

```ruby:
f2f.touch_all(subscribe_id: "feed/http://d.hatena.ne.jp/shu223/rss",
              entry_id: "8fPKPXQE24TE54JEOGjF2sZj8ETeM/gFTA93+y2aPso=_148ff50f96b:56909a5:9c034b5e")
```

## Installation

Add this line to your application's Gemfile:

    gem 'feedly2fastladder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install feedly2fastladder

## Tests

    $ rspec spec/

## Contributing

1. Fork it ( https://github.com/laiso/feedly2fastladder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
