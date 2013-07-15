# mission.rb
# Mission statement generator

require 'nokogiri'
require 'open-uri'

class MissionStatement < Isis::Plugin::Base
  TRIGGERS = %w(!missionstatement !mission !ms)

  def respond_to_msg?(msg, speaker)
    @commands = msg.downcase.split
    TRIGGERS.include? @commands[0]
  end

  private

  def response_html
    "<b>Our mission statement:</b> #{statement}"
  end

  def response_text
    "Our mission statement: #{statement}"
  end

  def statement
    case rand(0..2)
    when 0
      laughing_buddha
    when 1
      comfychair
    when 2
      talbot
    end
  end

  def laughing_buddha
    page = Nokogiri.HTML(open('http://www.laughing-buddha.net/toys/mission?'))
    page.css('#content p')[1].text.strip
  end

  def comfychair
    page = Nokogiri.HTML(open('http://www.lotta.se/mission-statement-generator/'))
    page.css('div div div div').text.strip  # lol wut. classes and ids are for sissies
  end

  # Nokogiri not working on this page anymore, so let's Regexp
  def talbot
    regex = Regexp.new('<h2>(?<content>.*)?</h2>', Regexp::IGNORECASE | Regexp::MULTILINE)
    content = open('http://www.harding.motd.ca/cgi-bin/msgen').read
    matches = regex.match(content)
    matches[:content].strip.gsub(/\n/, ' ')
  end
end
