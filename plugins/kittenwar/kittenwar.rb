require 'nokogiri'
require 'open-uri'

class KittenWar < Isis::Plugin::Base
  TRIGGERS = %w(!kittenwar)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    s = scrape
    %Q(#{s[:name0]} vs. #{s[:name1]}<br><img src="#{s[:root_url]}#{s[:pic0]}"><img src="#{s[:root_url]}) +
    %Q(#{s[:vs]}"><img src="#{s[:root_url]}#{s[:pic1]}">)
  end

  def response_text
    s = scrape
    ["#{s[:name0]} vs. #{s[:name1]}", "#{s[:root_url]}#{s[:pic0]}", "#{s[:root_url]}#{s[:pic1]}"]
  end

  def scrape
    root_url = 'http://www.kittenwar.com'
    page = Nokogiri.HTML(open(root_url))
    cells = page.css('#kittens td')
    names = [cells[0].css('p b').text, cells[2].css('p b').text]
    pics = [cells[0].css('a img').attr('src').value, cells[2].css('a img').attr('src').value]
    vs = cells[1].css('img').attr('src').value
    { name0: names[0], name1: names[1], root_url: root_url, pic0: pics[0], pic1: pics[1], vs: vs }
  end
end
