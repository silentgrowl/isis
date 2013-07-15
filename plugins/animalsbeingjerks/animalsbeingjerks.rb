require 'nokogiri'
require 'open-uri'

class AnimalsBeingJerks < Isis::Plugin::Base

  TRIGGERS = %w(!animalsbeingjerks !jerks !abj)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    page = Nokogiri.HTML(open('http://animalsbeingdicks.com/random'))
    img = page.css('.entry img').attr('src').value
    "<img src=\"#{img}\">"
  end

  def response_text
    page = Nokogiri.HTML(open('http://animalsbeingdicks.com/random'))
    img = page.css('.entry img').attr('src').value
    "#{img}"
  end
end
