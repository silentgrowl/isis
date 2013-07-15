require 'spec_helper'
require_relative '../../plugins/stockticker/stockticker'

describe StockTicker do
  let(:yf) { StockTicker.new(MockBot.new) }

  context '#response' do
    it 'outputs the quotes in text' do
      output = yf.response(['text']).content.join(' ')
      expect(output).to match(/ISIS Stock Ticker/)
      expect(output).to match(/powered by Yahoo! Finance/)
    end

    it 'outputs the quotes in HTML' do
      output = yf.response(['html']).content
      expect(output).to match(/ISIS Stock Ticker/)
      expect(output).to match(/powered by Yahoo! Finance/)
    end
  end

  context '#percentize' do
    it 'adds a plus to positive numbers' do
      expect(yf.send(:percentize, 1.04).to_s).to eq('+1.04%')
    end
    it 'does not add a plus to negative numbers' do
      expect(yf.send(:percentize, -2.45).to_s).to eq('-2.45%')
    end
  end
end
