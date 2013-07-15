# isup.rb
# Website status check

require 'nokogiri'
require 'open-uri'

class IsUp < Isis::Plugin::Base
  DOMAIN_REGEX = /^[a-z0-9]+([\-]{1}[a-z0-9]+)*\.[a-z]{2,5}$/ix

  def respond_to_msg?(msg, speaker)
    @commands = msg.downcase.split
    @commands[0] == '!isup'
  end

  private

  def response_html
    response = scrape
    return %Q(Sorry, I can't process that name) unless response
    if response =~ /It's just you/
      "#{domain} appears to be up. All good."
    else
      "#{domain} appears to be <b>down</b>! Panic!"
    end
  end

  def response_text
    response = scrape
    return %Q(Sorry, I can't process that name) unless response
    if response =~ /It's just you/
      "#{domain} appears to be up. All good."
    else
      "#{domain} appears to be down! Panic!"
    end
  end

  def scrape
    domain = @commands[1]
    domain = domain.split('www.')[1] if /www\./.match(domain)
    if DOMAIN_REGEX.match(domain)
      page = Nokogiri.HTML(open('http://isup.me/#{domain}'))
      page.css('#container').text
    else
      false
    end
  end
end
