# familycircus.rb
# Nietzsche Family Circus

require 'nokogiri'
require 'open-uri'

class FamilyCircus < Isis::Plugin::Base
  TRIGGERS = %w(!nietzsche !familycircus !nfc)

  def respond_to_msg?(msg, speaker)
    (/\bnietzsche\b/i =~ msg) || TRIGGERS.include?(msg.downcase)
  end

  private

  def response_html
    c = scrape
    %Q[<img src="#{c[:image]}"><br>#{word_wrap(c[:text])}<br>&nbsp;(<a href="#{c[:link]}">link</a>] +
    %Q[- Nietzsche Family Circus)]
  end

  def response_text
    c = scrape
    [c[:image], c[:text], c[:link], 'Nietzsche Family Circus']
  end

  def scrape
    page = Nokogiri.HTML(open('http://nietzschefamilycircus.com'))
    image = page.css('.comic img').attr('src').value
    text = page.css('.quote').text
    link = page.css('.description a')[1].attr('href')
    { image: image, text: text, link: link }
  end

  def word_wrap(text, max_width = 50)
    output = '&nbsp;'
    count = 0
    text.split(' ').each do |w|
      if count + w.length < max_width
        output += w + ' '
        count += (w.length + 1)
      else
        output += '<br>&nbsp;' + w + ' '
        count = (w.length + 1)
      end
    end
    output
  end
end
