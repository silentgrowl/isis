require 'nokogiri'
require 'open-uri'

class DailyKitten < Isis::Plugin::Base

  TRIGGERS = %w(!dailykitten)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    kitten = scrape
    %Q(<strong>The Daily Kitten</strong><br><em>#{kitten[:header]}</em><br><img src="#{kitten[:image]}" />)
  end

  def response_text
    kitten = scrape
    [kitten[:header], kitten[:image]]
  end

  def scrape
    page = Nokogiri.HTML(open('http://dailykitten.com'))
    header = page.css('h2 a').text
    image = page.css('img.kitten').attr('src').value
    { header: header, image: image }
  end
end
