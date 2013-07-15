require 'spec_helper'
require_relative '../../plugins/bbcworldnews/bbcworldnews'

describe BBCWorldNews do
  let(:bbc) { BBCWorldNews.new(MockBot.new) }

  context '#response' do
    it 'outputs the top stories' do
      output = bbc.response(['text'])
      expect(output.content.join(' ')).to match(/powered by BBC World News/)
    end
  end
end
