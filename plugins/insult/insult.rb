# insult.rb
# Insult user

require 'nokogiri'
require 'open-uri'

class Insult < Isis::Plugin::Base
  TRIGGERS = %w(!insult !ins)

  def respond_to_msg?(msg, speaker)
    @commands = msg.downcase.split
    TRIGGERS.include? @commands[0]
  end

  private

  def response_text
    subject = @commands[1].gsub('@', '')
    insult = case rand(0..7)
             when 0, 1, 2
               randominsults
             when 3
               pirate
             when 4
               autoinsult_modern
             when 5
               shakespeare
             when 6
               autoinsult_arabian
             when 7
               autoinsult_mediterranean
             end
    "@#{subject} #{insult}"
  end

  def randominsults
    page = Nokogiri.HTML(open('http://www.randominsults.net/'))
    page.css('i').text.strip
  end

  def pirate
    open('http://pir.to/api/insult').string
  end

  def autoinsult_modern
    page = Nokogiri.HTML(open('http://www.autoinsult.com/webinsult.php?style=3'))
    page.css('.insult').text
  end

  def autoinsult_arabian
    page = Nokogiri.HTML(open('http://www.autoinsult.com/webinsult.php?style=0'))
    page.css('.insult').text
  end

  def autoinsult_mediterranean
    page = Nokogiri.HTML(open('http://www.autoinsult.com/webinsult.php?style=2'))
    page.css('.insult').text
  end

  def shakespeare
    page = Nokogiri.HTML(open('http://www.pangloss.com/seidel/Shaker/index.html?'))
    page.css('p')[0].text.strip
  end
end
