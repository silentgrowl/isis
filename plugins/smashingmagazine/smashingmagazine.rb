# Latest items from Smashing Magazine RSS feed

require 'open-uri'
require 'rss'

class SmashingMagazine < Isis::Plugin::Base
  TRIGGERS = %w(!smashingmagazine !smashing)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    feed_items.reduce('<img src="http://i.imgur.com/MvCFkeg.png"> Smashing Magazine: Latest Posts<br>') do |a, e|
      a += %Q(<a href="#{e.link.href}">#{e.title.content}</a><br>)
    end
  end

  def response_text
    feed_items.reduce(['Smashing Magazine: Latest Posts']) do |output, item|
      output.push "#{item.title.content}: #{item.link.href}"
    end
  end

  def feed_items
    feed = RSS::Parser.parse(open('http://rss1.smashingmagazine.com/feed/'))
    feed.items[0..4]
  end
end
