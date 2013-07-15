# Design Milk posts from the past day

require 'open-uri'
require 'rss'

class DesignMilk < Isis::Plugin::Base

  TRIGGERS = %w(!designmilk !dm)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    feed_items.reduce('<img src="http://i.imgur.com/qUehCmD.png"> Design Milk: Latest Posts<br>') do |a, e|
      a += %Q(<a href="#{e.link}">#{e.title}</a><br>)
    end
  end

  def response_text
    feed_items.reduce(['Design Milk: Latest Posts']) { |a, e| a.push "#{e.title}: #{e.link}" }
  end

  def feed_items
    feed = RSS::Parser.parse(open('http://feeds.feedburner.com/design-milk'))
    feed.items[0..4]
  end
end
