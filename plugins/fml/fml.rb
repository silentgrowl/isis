require 'nokogiri'
require 'open-uri'

class FML < Isis::Plugin::Base

  def respond_to_msg?(msg, speaker)
    /\b[!]?fml\b/i =~ msg
  end

  private

  def response_text
    f = fml
    %Q[FML #{f[:number]}: "#{f[:fml]}" (link: http://fmylife.com#{f[:link]})]
  end

  def fml
    page = Nokogiri.HTML(open('http://www.fmylife.com/random'))
    selected = rand(page.css('.article > p').length)
    fml = page.css('.article > p')[selected].text
    link = page.css('.article > p')[selected].css('a').first['href']
    number = page.css('.article')[selected].css('.date .left_part a').text
    { number: number, fml: fml, link: link }
  end
end
