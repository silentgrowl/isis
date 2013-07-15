require 'time'

class Scheduler < Isis::Plugin::Base
  attr_reader :response_type

  def setup
    @schedule = []
    puts sprintf('Current time is: %02d:%02d', now.hour, now.min) if ENV['DEBUG']
    load_from_config
  end

  # This will only return the first not-yet-spoken scheduled match, but we
  # hit this method every few seconds, so items with the same scheduled time
  # will each get their turn, a few seconds apart
  def timer_response(types)
    @schedule.each do |s|
      if speak_now?(s)
        @bot.plugins.each do |p|
          if p.class.to_s.split('::').last == s['plugin']
            response = p.response(types)
            response.room = s['room']
            s['last'] = now
            return response
          end
        end
      end
    end
    nil
  end

  private

  def load_from_config
    config_file = File.join(File.dirname(__FILE__), 'scheduler.yml')
    raise Isis::Plugin::PluginSetupError, 'scheduler.yml config file not found' unless File.exists?(config_file)
    config = YAML.load(File.read(config_file))
    config.each do |key, item|
      next unless valid_item(item)
      t = Time.parse(item['time'])
      defaults = { 'hour' => t.hour, 'min' => t.min, 'day' => nil, 'weekdays' => false,
                   'weekends' => false, 'last' => nil }
      add_to_schedule(defaults.merge(item))
    end
  end

  def add_to_schedule(item)
    @schedule << item
  end

  def valid_item(item)
    item['plugin'].blank? || item['time'].blank? ? false : true
  end

  def speak_now?(s)
    return false if s['last'] && today?(s['last'])
    return false unless now.hour == s['hour'] && now.min == s['min']
    return false unless speak_day?(s) || speak_weekday?(s) || speak_weekend?(s)
    true
  end

  def today?(previous)
    last = previous.to_date
    last.day == now.day && last.month == now.month && last.year == now.year
  end

  def speak_day?(s)
    s['day'] == now.wday
  end

  def speak_weekday?(s)
    s['weekdays'] && (1..5).include?(now.wday)
  end

  def speak_weekend?(s)
    s['weekends'] && [0, 6].include?(now.wday)
  end
end
