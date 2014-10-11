# -*- coding: utf-8 -*-

require 'json'
require 'rspec'

require 'feedly2fastladder'

unless ENV["FEEDLY_TOKEN"]
  STDERR.write "[ERROR] Set a enviroment value FEEDLY_TOKEN your auth token.\n"
  exit 1
end

describe 'F2F' do
  before(:each) do
    @f2f = Feedly2fastladder.new(token: ENV["FEEDLY_TOKEN"])
  end

  describe '#subs all feeds' do
    before(:each) do
      @subs_json = @f2f.subs(unread: false)
    end

    example "should subs response is valid JSON" do
      parsable = JSON.parse(@subs_json).count > 0
      expect(parsable).to eq(true)
    end

    example "should convert to FL-JSON" do
      feed_item= JSON.parse(@subs_json)
      item = feed_item.first
      expect(item["subscribers_count"]).to be_a Integer
      expect(item["modified_on"]).to be_a Fixnum
      expect(item["title"]).to be_a String
      expect(item["folder"]).to be_a String
      expect(item["link"]).to start_with "http"
      expect(item["feedlink"]).to start_with "http"
      expect(item["public"]).to eq 1
    end
  end

  describe '#subs unread feeds' do
    before(:each) do
      @subs_json = @f2f.subs(true)
    end

    example "should fetch the unread feeds" do
      subs = JSON.parse(@subs_json)
      subs.each do |feed|
        expect(feed["unread_count"].to_i > 0).to be_truthy
      end
    end
  end

  describe '#unread' do
    example "should load a feed" do
      result = @f2f.unread 'feed/http://blogs.jetbrains.com/ruby/feed/'
      feed = JSON.parse result
      expect(feed["title"]).to eq("JetBrains RubyMine Blog")
    end
  end

  describe '#touch_all' do
    example "should mark read the feed" do
      result = @f2f.touch_all("feed/http://d.hatena.ne.jp/shu223/rss",
                              "8fPKPXQE24TE54JEOGjF2sZj8ETeM/gFTA93+y2aPso=_148ff50f96b:56909a5:9c034b5e")
      expect(result).to be_truthy
    end
  end

end