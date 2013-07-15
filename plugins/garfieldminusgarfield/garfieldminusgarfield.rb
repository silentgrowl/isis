# garfield.rb
# Random 'Garfield Minus Garfield' comic

require 'nokogiri'
require 'open-uri'

class GarfieldMinusGarfield < Isis::Plugin::Base
  TRIGGERS = %w(!garfield !gmg !minusgarfield !garfieldminusgarfield)

  def respond_to_msg?(msg, speaker)
    (/\bgarfield\b/i =~ msg) || TRIGGERS.include?(msg)
  end

  private

  def response_html
    c = scrape
    %Q[<img src="#{c[:image]}"><br>(<a href="#{c[:url]}">link</a> - Garfield Minus Garfield)]
  end

  def response_text
    c = scrape
    [c[:image], c[:url], 'Garfield Minus Garfield']
  end

  def scrape
    home_page = Nokogiri.HTML(open('http://garfieldminusgarfield.net'))
    last_page = home_page.css('#lastpage').attr('href').value.split('/').last
    page_number = rand(2..last_page.to_i)
    url = "http://garfieldminusgarfield.net/page/#{page_number}"
    page = Nokogiri.HTML(open(url))
    image = page.css('.photo a img').attr('src').value
    { image: image, url: url }
  end
end
