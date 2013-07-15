# epicfail.rb
# Random post from epicfail.com

require 'nokogiri'
require 'open-uri'

class EpicFail < Isis::Plugin::Base

  def respond_to_msg?(msg, speaker)
    /\bfail\b/i =~ msg
  end

  private

  def response_text
    page_number = rand(1000)
    page = Nokogiri.HTML(open("http://www.epicfail.com/page/#{page_number}"))
    post = page.css('.post')[rand(page.css('.post').length)]
    image = post.css('.post-content a img').attr('src').value
    title = post.css('.post-title a').first.text
    [image, title]
  end
end
