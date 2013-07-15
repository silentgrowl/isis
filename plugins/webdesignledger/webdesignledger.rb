# Web Design Ledger posts from past week

require 'open-uri'
require 'rss'

class WebDesignLedger < Isis::Plugin::Base
  TRIGGERS = %w(!webdesignledger !wdl)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    output = '<img src="http://i.imgur.com/r4F4a3h.png"> Web Design Ledger: Posts from the past week<br>'
    feed_items.reduce(output) do |a, e|
      a += %Q(<a href="#{e.link}">#{e.title}</a><br>)
    end
  end

  def response_text
    feed_items.reduce(['Web Design Ledger: Posts from the past week']) do |a, e|
      a.push "#{e.title}: #{e.link}"
    end
  end

  def feed_items
    feed = RSS::Parser.parse(open('http://feeds.feedburner.com/WebDesignLedger'))
    last_week = Time.now - (60 * 60 * 24 * 7)
    feed.items.select { |i| i.date > last_week }
  end
end
