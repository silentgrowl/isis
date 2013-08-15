# pizza.rb
# Random 'Animated Pizza GIF'

require 'nokogiri'
require 'open-uri'

class PizzaGifs < Isis::Plugin::Base
  def respond_to_msg?(msg, speaker)
    /\bpizza\b/i =~ msg
  end

  private

  def response_text
    scrape
  end

  def scrape
    page = Nokogiri.HTML(open('http://animatedpizzagifs.com'))
    last_page = page.css('li.page')[-2].text.strip
    page_num = rand(1..last_page.to_i)
    page = Nokogiri.HTML(open("http://animatedpizzagifs.com/page#{page_num}")) if page_num > 1
    images = page.css('div.gif a img')
    image = images[rand(1..images.count - 1)].attr('src')
    "http://animatedpizzagifs.com/#{image}"
  end
end
