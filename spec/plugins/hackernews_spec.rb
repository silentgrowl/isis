require 'spec_helper'
require_relative '../../plugins/hackernews/hackernews'

describe HackerNews do
  let(:hn) { HackerNews.new(MockBot.new) }

  context '#response' do
    it 'outputs the top stories in text' do
      output = hn.response(['text']).content.join(' ')
      expect(output).to match(/HackerNews Top Stories/)
    end

    it 'outputs the top stories in HTML' do
      output = hn.response(['html']).content
      expect(output).to match(/HackerNews Top Stories/)
      expect(output).to match(/points/)
      expect(output).to match(/a href/)
    end
  end
end
