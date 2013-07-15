# xkcd

require 'nokogiri'
require 'open-uri'

class XKCD < Isis::Plugin::Base
  def respond_to_msg?(msg, speaker)
    @commands = msg.split
    @commands[0] == '!xkcd'
  end

  private

  def response_html
    comic = parse_command
    if comic.is_a?(Hash)
      %Q(#{comic[:title]}<br><img src="#{comic[:image]['src']}"><br>#{comic[:image]['title']})
    else
      comic
    end
  end

  def response_text
    comic = parse_command
    if comic.is_a?(Hash)
      [comic[:title], comic[:image]['src'], comic[:image]['title']]
    else
      comic
    end
  end

  def parse_command
    return new_comic if @commands[1].nil?

    case @commands[1].downcase
    when 'random'
      random_comic
    when 'new'
      new_comic
    when 'commands'
      'Understood command arguments for !xkcd: new, random'
    else
      "I have no idea what #{@commands[1]} means. No comic for you"
    end
  end

  def new_comic
    scrape(Nokogiri.HTML(open('http://xkcd.com/')))
  end

  def random_comic
    scrape(Nokogiri.HTML(open('http://dynamic.xkcd.com/random/comic/')))
  end

  def scrape(page)
    image = page.css('#comic img').first
    title = page.css('#ctitle').text
    { image: image, title: title }
  end
end
