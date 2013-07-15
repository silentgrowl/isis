# awkward.rb
# Random 'Awkward Family Photos' picture

require 'nokogiri'
require 'open-uri'

class AwkwardFamilyPhotos < Isis::Plugin::Base
  def respond_to_msg?(msg, speaker)
    /\bawkward\b/i =~ msg
  end

  private

  def response_html
    content = scrape
    "#{content[:title]}<br><img src=\"#{content[:image]}\" /><br>" +
    "(<a href=\"#{content[:url]}\">link</a> - Awkward Family Photos)"
  end

  def response_text
    content = scrape
    [content[:title], content[:image], "#{content[:url]} - Awkward Family Photos"]
  end

  def scrape
    home_page = Nokogiri.HTML(open('http://www.awkwardfamilyphotos.com'))
    pagination_links = home_page.css('.pagination a')
    last_page = pagination_links[pagination_links.count - 2].text
    page_number = rand(1..last_page.to_i)
    url = "http://www.awkwardfamilyphotos.com/page/#{page_number}"
    page = Nokogiri.HTML(open(url))
    posts = page.css('.post .text')
    post = posts[rand(1..posts.count)]
    image = post.css('a.img img').attr('src').value
    url = post.css('a.img').attr('href').value
    title = post.css('h2 a').text
    { title: title, image: image, url: url }
  end
end
