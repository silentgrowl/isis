# Latest stories on RubyFlow

require 'nokogiri'
require 'open-uri'

class RubyFlow < Isis::Plugin::Base
  TRIGGERS = %w(!rf !rubyflow)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    output = %Q[<img src="http://i.imgur.com/TG59FAb.png"> RubyFlow Latest Links] +
             %Q[- #{timestamp} #{zone}<br>]
    scrape.reduce(output) do |a, e|
      link = e.children.css('a')
      # &nbsp; is an evil bitch, refusing to be .strip'd, eq to ' ', or match [[:space:]]
      host = e.children.css('span').text.gsub(/^[a-zA-Z0-9\.[[:space:]]]/, '')
      a += %Q[<a href="#{link.attr('href').value}">#{link.text}</a>]
      a += "&nbsp;(from #{host})" if host.length > 0
      a += '<br>'
    end
  end

  def response_text
    output = ["RubyFlow Latest Links - #{timestamp} #{zone}"]
    scrape.reduce(output) do |a, e|
      link = e.children.css('a')
      a.push %Q[#{link.text}: #{link.attr('href').value}]
    end
  end

  def scrape
    page = Nokogiri.HTML(open('http://www.rubyflow.com'))
    page.css('.post .entry .ptitle')[0..4]
  end
end
