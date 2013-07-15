require 'json'
require 'open-uri'

class CatFacts < Isis::Plugin::Base

  TRIGGERS = %w(!catfacts !cf)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def response_text
    response = JSON.load(open('http://catfacts-api.appspot.com/api/facts?number=1'))
    response['facts'].first.strip
  end
end
