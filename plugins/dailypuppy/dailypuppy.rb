require 'nokogiri'
require 'open-uri'

class DailyPuppy < Isis::Plugin::Base

  TRIGGERS = %w(!dailypuppy)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    puppy = scrape
    %Q(<strong>The Daily Puppy</strong><br><em>#{puppy[:header]}</em><br><img src="#{puppy[:image]}" />)
  end

  def response_text
    puppy = scrape
    [puppy[:header], puppy[:image]]
  end

  def scrape
    page = Nokogiri.HTML(open('http://dailypuppy.com'))
    header = page.css('h2.title a').first.text
    image = page.css('.post_overlay a img').attr('src').value
    { header: header, image: image }
  end
end
