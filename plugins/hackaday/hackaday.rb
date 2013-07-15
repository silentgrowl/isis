require 'nokogiri'
require 'open-uri'

class HackADay < Isis::Plugin::Base
  TRIGGERS = %w(!hackaday !hack)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    s = scrape
    output = %Q[<img src="http://i.imgur.com/UI8k6wJ.jpg"> Hack a Day: Most Recent] +
             %Q[ - #{timestamp} #{zone}<br>]
    s[:entries].each do |e|
      link = e.children.css('h2.entry-title a')
      tags = e.children.css('div.post-meta span.tags a')
      output += %Q[<a href="#{link.attr('href').value}">#{link.text}</a>]
      unless tags.nil?
        output += '&nbsp;(tags:'
        tags.each { |tag| output += %Q[&nbsp;<a style="color: black;" href="#{tag.attr("href")}">#{tag.text}</a>] }
        output += ')'
      end
      output += '<br>'
    end
    output
  end

  def response_text
    s = scrape
    output = ["Hack a Day: Most Recent - #{timestamp} #{zone}"]
    s[:entries].each do |e|
      link = e.children.css('h2.entry-title a')
      output.push "#{link.text}: #{link.attr('href').value}"
    end
    output
  end

  def scrape
    page = Nokogiri.HTML(open('http://www.hackaday.com'))
    entries = page.css('.post')[0..4]
    { page: page, entries: entries }
  end
end
