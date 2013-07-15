require 'nokogiri'
require 'open-uri'

class BBCWorldNews < Isis::Plugin::Base

  def respond_to_msg?(msg, speaker)
    msg.downcase == '!bbc'
  end

  private

  def response_html
    output = %Q[<img src='http://i.imgur.com/jxh78YE.png'> ISIS World News Report] +
             %Q[- #{timestamp} #{zone} (powered by BBC World News)<br>]
    page = Nokogiri.HTML(open('http://www.bbc.co.uk/news/10628323'))
    articles = page.css('#range-top-stories ul li')
    articles.each do |a|
      output += %Q[<a href="http://www.bbc.co.uk#{a.css('a').attr('href').value}">] +
                %Q[#{a.text.gsub(/(\n|\t)/, '')}</a><br>]
    end
    output
  end

  def response_text
    output = []
    output.push %Q(ISIS World News Report - #{timestamp} #{zone}) +
                %Q{ (powered by BBC World News)}
    page = Nokogiri.HTML(open('http://www.bbc.co.uk/news/10628323'))
    articles = page.css('#range-top-stories ul li')
    articles.each do |a|
      output.push %Q(#{a.text.gsub(/(\n|\t)/, '')} - http://www.bbc.co.uk#{a.css('a').attr('href').value})
    end
    output
  end
end
