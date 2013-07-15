# compliment.rb
# Compliment user

require 'nokogiri'
require 'open-uri'
require 'rhino' if RUBY_PLATFORM =~ /java/
require 'v8' if RUBY_PLATFORM =~ /ruby/

class Compliment < Isis::Plugin::Base

  TRIGGERS = ['!compliment', '!comp']

  def respond_to_msg?(msg, speaker)
    @commands = msg.downcase.split
    TRIGGERS.include? @commands[0]
  end

  private

  def response_text
    subject = @commands[1].gsub('@', '')
    compliment = case rand(0..2)
                 when 0
                   toykeeper
                 when 1
                   emergency_compliment
                 when 2
                   multicomp
                 end
    "@#{subject} #{compliment}"
  end

  def toykeeper
    page = Nokogiri.HTML(open('http://toykeeper.net/programs/mad/compliments'))
    page.css('.blurb_title_1').text.strip
  end

  def emergency_compliment
    case RUBY_PLATFORM
    when 'java'
      Rhino::Context.open do |cxt|
        cxt.eval(open('http://emergencycompliment.com/js/compliments.js').string)
        cxt.eval('compliments[Math.floor(Math.random() * compliments.length)].phrase')
      end
    when 'ruby'
      V8::Context.new do |cxt|
        cxt.eval(open('http://emergencycompliment.com/js/compliments.js').string)
        cxt.eval('compliments[Math.floor(Math.random() * compliments.length)].phrase')
      end
    end
  end

  def multicomp
    page = Nokogiri.HTML(open('http://www.supersilly.com/cgi/multicomp.cgi?num=1'))
    page.css('body').text.split('Give me')[0].strip
  end
end
