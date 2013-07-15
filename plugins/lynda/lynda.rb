# Lynda.com New Releases

require 'open-uri'
require 'rss'

class Lynda < Isis::Plugin::Base
  TRIGGERS = %w(!lynda)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    feed_items.reduce('Lynda.com New Releases<br>') do |output, item|
      output += %Q(<a href="#{item.link}">#{item.title}</a><br>)
    end
  end

  def response_text
    feed_items.reduce(['Lynda.com New Releases']) do |output, item|
      output.push "#{item.title}: #{item.link}"
    end
  end

  def feed_items
    feed = RSS::Parser.parse(open('http://feeds2.feedburner.com/lyndablog'))
    feed.items[0..4]
  end
end
