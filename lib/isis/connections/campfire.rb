# Campfire connection

require 'tinder'
require 'isis/connections/base'

class Isis::Connections::Campfire < Isis::Connections::Base
  RESPONSE_TYPES = %w(text)
  attr_accessor :client, :rooms

  def initialize(config)
    load_config(config)
    create_client
  end

  # connects automatically when client is created
  def connect
    nil
  end

  def still_connected?
    # TODO: Check that connection is still live - returning TRUE for now
    true
  end

  def join
    join_rooms
  end

  def join_rooms
    @rooms = []
    @config['campfire']['rooms'].each do |rm|
      room = @client.find_room_by_name(rm)
      room.join
      message_loop(room)
      @rooms << room
    end
  end

  def speak(room, message, type = 'text')
    room.speak message
    puts %Q(saying: #{message})
  end

  def timer_response
    @plugins.each do |plugin|
      response = plugin.timer_response(RESPONSE_TYPES)
      speak_response(response)
    end
  end

  private

  def create_client
    if @config['campfire']['auth_mode'] == 'api'
      @client = Tinder::Campfire.new config['campfire']['subdomain'],
                                     token: config['campfire']['api_key']
    elsif config['campfire']['auth_mode'] == 'username'
      @client = Tinder::Campfire.new config['campfire']['subdomain'],
                                     username: config['campfire']['username'],
                                     password: config['campfire']['password']
    else
      puts 'Invalid authentication mode set - please check auth_mode settings in config.yml'
      exit
    end
    @name = @client.me[:name]
    @join_time = Time.now
  end

  def speak_response(response, room = nil)
    unless response.blank?
      if response.content.respond_to?('each')
        response.content.each { |line| speak(room, line, response.type) }
      else
        speak(room, response.content, response.type)
      end
    end
  end

  def message_loop(room)
    room.listen do |message|
      if %w(TextMessage PasteMessage).include? message[:type]
        puts "message hash: #{message} in room: #{room.name}"
        msg = Isis::Message.new(content: message[:body], speaker: message[:user][:name], room: room.name)
        unless speaker == @name
          puts %Q(MESSAGE: r:#{room.name} s:#{msg.speaker} m:#{msg.content})
          @plugins.each do |plugin|
            begin
              response = plugin.receive_message(msg, RESPONSE_TYPES)
              speak_response(response, room)
            rescue => e
              puts "ERROR: Plugin #{plugin.class.name} just crashed"
              puts "Message: #{e.message}"
            end
          end
        end
      end
    end
  end
end
