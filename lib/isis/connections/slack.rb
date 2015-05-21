# Slack connection

require 'slack'

class Isis::Connections::Slack < Isis::Connections::Base
  RESPONSE_TYPES = %w(md text)

  def initialize(config)
    load_config(config)
    configure_slack
    @speakers = {}
    @channel_names = {}
    @user_id = Slack.auth_test["user_id"]
  end

  def connect
    join_channels
    create_realtime_client
    set_message_handler
    @client.start
    @join_time = Time.now
  end

  # TODO: add real connection check
  def still_connected?
    true
  end

  def join
    nil
  end

  def set_message_handler
    @client.on(:message) do |e|
      # type = e["type"]
      message = e["text"]
      speaker_id = e["user"]
      channel_id = e["channel"]
      speaker = speaker_name(speaker_id)
      room = channel_name(channel_id)

      unless speaker_id == @user_id || speaker_id.nil?
        begin
          msg = Isis::Message.new(content: message, speaker: speaker, room: room)
          puts %Q(MESSAGE: r:#{room} s:#{msg.speaker} m:#{msg.content})
        rescue => e
          puts "ERROR in message handler"
          puts "Message: #{e.message}"
        end
        @plugins.each do |plugin|
          Thread.new do
            begin
              puts "Sending message to #{plugin}" if ENV['DEBUG']
              response = plugin.receive_message(msg, RESPONSE_TYPES)
              response.room = room if response.is_a?(Isis::Plugin::Base::Response)
              speak_response(response)
            rescue => e
              puts "ERROR: Plugin #{plugin.class.name} just crashed"
              puts "Message: #{e.message}"
            end
          end
        end
      end
    end
  end

  def timer_response
    @plugins.each do |plugin|
      response = plugin.timer_response(RESPONSE_TYPES)
      speak_response(response)
    end
  end

  private

  def configure_slack
    Slack.configure do |config|
      config.token = @config['slack']['token']
      puts "token: #{config.token}" if ENV['DEBUG']
    end
    @username = @config['slack']['username']
    @name = @config['slack']['name']
    @icon = @config['slack']['icon']
    @channels = @config['slack']['channels']
  end

  def create_realtime_client
    @client = Slack.realtime
  end

  def join_channels
    @channels.each do |ch|
      Slack.channels_join(name: ch)
    end
  end

  def speaker_name(speaker_id)
    unless speaker_id.nil?
      @speakers[speaker_id.to_sym] ||= Slack.users_info(user: speaker_id)["user"]["name"]
    end
  end

  def channel_name(channel_id)
    unless channel_id.nil?
      name = case channel_id[0]
             when "C"
               Slack.channels_info(channel: channel_id)["channel"]["name"]
             when "G"
               Slack.groups_info(channel: channel_id)["group"]["name"]
             else
               raise "Unknown channel type"
             end
      @channel_names[channel_id.to_sym] ||= name
    end
  end

  def speak_response(response)
    unless response.blank?
      if response.content.respond_to?('each')
        response.content.each { |line| speak(room, line, response.type) }
      else
        speak(response.room, response.content, response.type)
      end
    end
  end

  def speak(room, message, type = 'text')
    if type == 'md'
      speak_md(room, message)
    else
      speak_text(room, message)
    end
  end

  def speak_md(room, message)
    Slack.chat_postMessage(channel: room, text: message, username: @username, name: @name, icon_url: @icon)
    puts %Q(saying: "#{message}")
  end

  def speak_text(room, message)
    Slack.chat_postMessage(channel: room, text: message, username: @username, name: @name, icon_url: @icon)
    puts %Q(saying: "#{message}")
  end
end
