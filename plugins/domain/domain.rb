# domain.rb
# Domain registration check

require 'whois'

class Domain < Isis::Plugin::Base

  DOMAIN_REGEX = /^[a-z0-9]+([\-]{1}[a-z0-9]+)*\.[a-z]{2,5}$/ix

  def respond_to_msg?(msg, speaker)
    @commands = msg.downcase.split
    @commands[0] == '!domain'
  end

  private

  def response_html
    result = domain_search
    return %Q(Sorry, I can't process that name) unless result
    if result[:r].available?
      %Q(#{result[:domain]} is <b>available</b>! <a href="#{registration_url(result[:domain])}">Register it!</a>)
    else
      "#{result[:domain]} is registered<br>#{registered(result[:r])}"
    end
  end

  def response_text
    result = domain_search
    return %Q(Sorry, I can't process that name) unless result
    if result[:r].available?
      ["#{domain} is available!", "Register it at: #{registration_url(domain)}"]
    else
      ["#{domain} is registered", registered(r)]
    end
  end

  def domain_search
    domain = @commands[1]
    domain = domain.split('www.')[1] if /www\./.match(domain)
    DOMAIN_REGEX.match(domain) ? { r: Whois.whois(domain), domain: domain } : nil
  end

  def registered(r)
    "Registered on #{r.created_on.strftime('%Y-%m-%d')} (expires #{r.expires_on.strftime('%Y-%m-%d')})"
  end

  def registration_url(domain)
    "http://www.dynadot.com/domain/search.html?domain=#{domain}"
  end
end
