# Uptime counter

require 'chronic_duration'

class Uptime < Isis::Plugin::Base
  def respond_to_msg?(msg, speaker)
    /[\b]?!uptime\b/i =~ msg
  end

  private

  def setup
    @boot = Time.now
    puts "Uptime-boot #{@boot}"
  end

  def response_text
    "Isis has been up for #{ChronicDuration.output(Time.now - @boot, format: :long)}," +
    " since #{@boot.strftime('%B %-d, %Y, %I:%M %P %Z')}."
  end
end
