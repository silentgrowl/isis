require 'ruby-hackernews'

class HackerNews < Isis::Plugin::Base
  TRIGGERS = %w(!hn !hackernews)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_html
    entries = RubyHackernews::Entry.all[0..4]
    output = '<img src="http://i.imgur.com/BskroOr.png"> HackerNews Top Stories'
    output += " - #{timestamp} #{zone}<br>"
    entries.reduce(output) do |a, e|
      a += "<a href=\"#{e.link.href}\">#{e.link.title}</a> (#{e.voting.score} points by #{e.user.name})<br>"
    end
  end

  def response_text
    entries = RubyHackernews::Entry.all[0..4]
    entries.reduce(["HackerNews Top Stories - #{timestamp} #{zone}"]) do |a, e|
      a.push "#{e.link.title}: #{e.link.href}"
    end
  end
end
