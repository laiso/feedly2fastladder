# -*- coding: utf-8 -*-
require 'faraday'
require 'json'

class Feedly2fastladder
  VERSION = "0.0.1"

  def initialize(token: token)
    @token = token
  end

  def subs(unread, from_id: 0, limit: 100)
    @is_unread_only = unread
    @unread_counts = unread_counts
    response = conn.get "/v3/subscriptions"
    convert_with_subs response.body
  end

  def unread(subscribe_id)
    response = conn.get "/v3/streams/contents", {
        streamId: subscribe_id.to_s,
        unreadOnly: true
    }
    convert_with_contents response.body
  end

  def touch_all(subscribe_id, entry_id)
    response = conn.post "/v3/markers" do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
          action: "markAsRead",
          type: "feeds",
          lastReadEntryId: entry_id,
          feedIds: [subscribe_id],
      }.to_json
    end
    response.status == 200
  end

  private
  def conn
    conn = Faraday.new url: "https://cloud.feedly.com"
    conn.headers["Authorization"] = "Bearer #{@token}"
    conn
  end

  def convert_with_subs(text)
    items = JSON.parse(text).map do |item|
      item[:public] = 1
      item[:rate] = item["sortid"]
      item[:unread_count] = unread_count_by_id item["id"]
      item[:subscribe_id] = item["id"]
      item[:subscribers_count] = item["subscribers"]
      item[:modified_on] = item["updated"]
      item[:folder] = item["categories"][0]["label"]
      item[:link] = item["website"]
      item[:feedlink] = item["id"].sub /\Afeed\//, ''
      item
    end
    items.select {|item| !@is_unread_only or item[:unread_count] > 0}.to_json
  end

  def convert_with_contents(text)
    contents = JSON.parse(text)
    contents[:subscribe_id] = contents["id"]
    contents[:channel] = {
        title: contents["title"],
        modified_on: contents["updated"],
    }
    contents[:items] = contents["items"].map do |item|
      item[:created_on] = item["published"]
      item[:modified_on] = item["updated"]
      item[:body] = item["content"]["content"] if item["content"]
      item[:link] = item["alternate"][0]["href"] if item["alternate"]
      item
    end
    contents.to_json
  end

  def unread_counts
    response = conn.get "/v3/markers/counts"
    JSON.parse(response.body)["unreadcounts"]
  end

  def unread_count_by_id(id)
    item = @unread_counts.find {|data| data["id"] == id}
    item["count"].to_i || 0
  end
end