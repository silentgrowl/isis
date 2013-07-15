require 'nokogiri'
require 'open-uri'

class ComputerHistory < Isis::Plugin::Base

  TRIGGERS = %w(!history !computerhistory)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    content = scrape
    output = %Q(<b>This Day in Computer History</b><br>#{content[:date]}: <em>#{content[:title]}</em><br>)
    output += %Q(<img src="#{content[:image]}"><br>) if content[:image] !~ /no_image/
    output += %Q(#{content[:story]})
  end

  def response_text
    content = scrape
    output = ['This Day in Computer History', "#{content[:date]}: #{content[:title]}"]
    output.push content[:image] if content[:image] !~ /no_image/
    output.push content[:story]
  end

  def scrape
    page = Nokogiri.HTML(open('http://www.computerhistory.org/tdih/'))
    body = page.css('.tdihevent')
    image = "http://www.computerhistory.org/#{body.css('img.main').attr('src')}"
    date = body.css('h3.title').text
    title = body.css('p.subtitle').text
    story = body.css('p')[1].text
    story == '' ? story = body.css('p')[2].text : nil # on some entries, there's a random blank paragraph
    { date: date, title: title, image: image, story: story }
  end

end
