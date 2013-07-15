# Penny Arcade comic

require 'nokogiri'
require 'open-uri'

class PennyArcade < Isis::Plugin::Base
  TRIGGERS = %w(!pa !pennyarcade)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    c = comic
    %Q(<img src="#{c['src']}"><br>#{c['alt']})
  end

  def response_text
    c = comic
    [c['src'], c['alt']]
  end

  def comic
    page = Nokogiri.HTML(open('http://www.penny-arcade.com/comic/'))
    page.css('.comic > img').first
  end
end
