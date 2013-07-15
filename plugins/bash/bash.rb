require 'nokogiri'
require 'open-uri'

class Bash < Isis::Plugin::Base

  def respond_to_msg?(msg, speaker)
    /\b[!]?bash\b/i =~ msg
  end

  private

  def response_text
    page = Nokogiri.HTML(open('http://bash.org?random1'))
    selected = rand(page.css('.quote').length)
    link = page.css('.quote')[selected].css('a').first['href']
    quote = page.css('.qt')[selected].text
    number = link.gsub('?', '')
    "bash.org ##{number}: \r\n#{quote}\r\n(link: http://bash.org#{link})"
  end
end
