require 'spec_helper'
require_relative '../../plugins/weather/weather'

describe Weather do
  let(:weather) { Weather.new(MockBot.new) }

  context '#response' do
    it 'should output the weather report in text' do
      output = weather.response(['text']).content.join(' ')
      expect(output).to match(/ISIS Weather Report/)
    end

    it 'should output the weather report in HTML' do
      output = weather.response(['html']).content
      expect(output).to match(/ISIS Weather Report/)
    end
  end
end
