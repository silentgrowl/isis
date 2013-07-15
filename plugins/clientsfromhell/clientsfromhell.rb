# clientsfromhell.rb
# Random story from clientsfromhell.net

require 'nokogiri'
require 'open-uri'

class ClientsFromHell < Isis::Plugin::Base

  TRIGGERS = %w(!clients !fromhell !clientsfromhell !cfh)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    page = Nokogiri.HTML(open('http://clientsfromhell.net/random'))
    story = page.css('.post-content').children.reject { |s| s.attr('class') == 'socialbuttons' }
                                              .join(' ').strip
                                              .split(/\n/)
                                              .map { |s| s.strip }
                                              .join('<br>')
                                              .gsub('Client:', '<strong>Client:</strong>')
                                              .gsub('Me:', '<strong>Me:</strong>')
    %Q(<img src="http://i.imgur.com/N5atudZ.png"><b>Clients from Hell!</b><br>#{story})
  end

  def response_text
    page = Nokogiri.HTML(open('http://clientsfromhell.net/random'))
    story = page.css('.post-content').children.reject { |s| s.attr('class') == 'socialbuttons' }
                                              .join(' ').strip
                                              .split(/\n/)
                                              .map { |s| s.strip }
    ['Clients from Hell!'] + story
  end
end
