require 'nokogiri'
require 'open-uri'

class DefProgramming < Isis::Plugin::Base

  TRIGGERS = %w(!quote !programming !def !defp !defprogramming)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_text
    page = Nokogiri.HTML(open('http://defprogramming.com/random'))
    quote = page.css('div.box cite p').text
    author = page.css('div.box p.author a').text
    %Q("#{quote}" -- #{author})
  end
end
