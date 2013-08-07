# excuses.rb
# Excuse generator

require 'nokogiri'
require 'open-uri'

class Excuses < Isis::Plugin::Base

  TRIGGERS = %w(!excuse !excuses)

  def respond_to_msg?(msg, speaker)
    @commands = msg.downcase.split
    TRIGGERS.include? @commands[0]
  end

  private

  def response_text
    excuse
  end

  def excuse
    case rand(0..1)
    when 0
      developer_excuses
    when 1
      bofh_excuses
    end
  end

  def developer_excuses
    page = Nokogiri.HTML(open('http://www.developerexcuses.com'))
    page.css('a').first.text.strip
  end

  def bofh_excuses
    page = Nokogiri.HTML(open('http://bofh.gotblah.com/'))
    page.css('pre').first.text.split("\n")[2].strip
  end
end
