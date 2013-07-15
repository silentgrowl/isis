# Stock Ticker

require 'yahoofinance'
require 'httparty'
require 'csv'
require 'json'

class StockTicker < Isis::Plugin::Base
  TRIGGERS = %w(!stockquotes !stocks !stockticker !yahoofinance !yf !ticker)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def setup
    @symbols = CSV.read(File.join(File.dirname(__FILE__), 'symbols.csv')).flatten
  end

  def response_html
    output = %Q[<img src="http://i.imgur.com/8QkyRrp.png"> ISIS Stock Ticker] +
             %Q[ - #{timestamp} #{zone} (powered by Yahoo! Finance)<br>]
    quotes = YahooFinance.get_standard_quotes(@symbols)
    quotes.each do |q|
      symbol = q[0]
      last_trade = q[1].lastTrade
      points = q[1].changePoints
      percent = q[1].changePercent
      name = company_name(symbol) || q[1].name
      output += html_output_line(name: name, symbol: symbol, last_trade: last_trade,
                                 points: points, percent: percent)
    end
    output
  end

  def response_text
    output = ["ISIS Stock Ticker - #{timestamp} #{zone} (powered by Yahoo! Finance)"]
    quotes = YahooFinance.get_standard_quotes(@symbols)
    quotes.each do |q|
      symbol = q[0]
      last_trade = q[1].lastTrade
      points = q[1].changePoints
      percent = q[1].changePercent
      name = company_name(symbol) || q[1].name
      output.push text_output_line(name: name, symbol: symbol, last_trade: last_trade,
                                   points: points, percent: percent)
    end
    output
  end

  def html_output_line(opts)
    %Q[<b>#{opts[:name]}</b> (#{opts[:symbol]}): #{opts[:last_trade]} (#{pointize(opts[:points])},] +
    %Q[ #{percentize(opts[:percent])})<br>]
  end

  def text_output_line(opts)
    %Q[#{opts[:name]} (#{opts[:symbol]}): #{opts[:last_trade]} (#{pointize(opts[:points])},] +
    %[ #{percentize(opts[:percent])})]
  end

  def percentize(pct)
    pct.to_s[0] == '-' ? "#{pct}%" : "+#{pct}%"
  end

  def pointize(pts)
    pts.to_s[0] == '-' ? "#{pts}" : "+#{pts}"
  end

  # The silly gem returns truncated company names
  # So we make a call to Yahoo on our own to fetch the full name
  # TODO: Fix the gem or just parse this result for all the data
  def company_name(symbol)
    url = 'http://d.yimg.com/autoc.finance.yahoo.com/autoc'
    callback = 'YAHOO.Finance.SymbolSuggest.ssCallback'
    response = HTTParty.get("#{url}?query=#{symbol}&callback=#{callback}")
    info = JSON.parse(response.split('YAHOO.Finance.SymbolSuggest.ssCallback(')[1].gsub(')', ''))
    info['ResultSet']['Result'][0]['name']
  end
end
