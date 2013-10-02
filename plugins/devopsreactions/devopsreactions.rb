require 'nokogiri'
require 'open-uri'

class DevopsReactions < Isis::Plugin::Base

  TRIGGERS = %w(!devops !devopsreactions)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    page = Nokogiri.HTML(open('http://devopsreactions.tumblr.com/random'))
    img = page.css('.item_content p img').attr('src').value
    title = page.css('.post_title a').text
    "#{title} <img src=\"#{img}\">"
  end

  def response_text
    page = Nokogiri.HTML(open('http://devopsreactions.tumblr.com/random'))
    title = page.css('.post_title a').text
    "#{title} #{img}"
  end
end
