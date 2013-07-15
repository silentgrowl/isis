# Weather from Weather Underground

require 'barometer'
require 'csv'

class Weather < Isis::Plugin::Base
  TRIGGERS = %w(!weather)

  def respond_to_msg?(msg, speaker)
    TRIGGERS.include? msg.downcase
  end

  private

  def setup
    Barometer.config = { 1 => :wunderground }
    @zip_codes = CSV.read(File.join(File.dirname(__FILE__), 'weather.csv')).flatten
  end

  def response_html
    output = %Q[<img src="http://i.imgur.com/wJwbW5q.png"> ISIS Weather Report - #{timestamp} #{zone}] +
             %Q[ (powered by Weather Underground)<br>]
    @zip_codes.reduce(output) do |a, e|
      loc = Barometer.new(e).measure
      a += "#{forecast_html(loc)}<br>"
    end
  end

  def response_text
    output = ["ISIS Weather Report - #{timestamp} #{zone} (powered by Weather Underground"]
    @zip_codes.reduce(output) do |a, e|
      loc = Barometer.new(e).measure
      a.push forecast_text(loc)
    end
  end

  # Parse wunderground's icon codes into a text weather condition
  def parse_icon_codes(code)
    case code
    when 'flurries', 'rain', 'sleet', 'snow', 'clear', 'sunny', 'cloudy', 'fog', 'hazy'
      code.capitalize
    when 'chancerain', 'chanceflurries', 'chancesleet', 'chancesnow'
      "Chance of #{code.split('chance')[1].capitalize}"
    when 'nt_flurries', 'nt_rain', 'nt_sleet', 'nt_snow'
      "#{code.split('_')[1].capitalize}"
    when 'mostlysunny', 'mostlycloudy'
      "Mostly #{code.split('mostly')[1].capitalize}"
    when 'partlysunny', 'partlycloudy'
      "Partly #{code.split('partly')[1].capitalize}"
    when 'chancetstorms'
      'Chance of Thunderstorms'
    when 'tstorms'
      'Thunderstorms'
    when 'nt_tstorms'
      'Thunderstorms at Night'
    else
      '(no condition info)'
    end
  end

  def forecast_html(w)
    city = w.measurements.last.location.to_s.split(',')[0..1].join(',')
    %Q[#{city} - <b>Forecast:</b> #{parse_icon_codes(w.today.icon)}, High #{w.today.high}, Low #{w.today.low}.] +
    %Q[ <b>Current Conditions:</b> #{parse_icon_codes(w.now.icon)}, #{w.now.temperature}, wind #{w.now.wind}] +
    %Q[ #{w.now.wind.direction}]
  end

  def forecast_text(w)
    city = w.measurements.last.location.to_s.split(',')[0..1].join(',')
    %Q[#{city} - Forecast: #{parse_icon_codes(w.today.icon)}, High #{w.today.high}, Low #{w.today.low}.] +
    %Q[ Current Conditions: #{parse_icon_codes(w.now.icon)}, #{w.now.temperature}, wind #{w.now.wind}] +
    %Q[ #{w.now.wind.direction}]
  end
end
