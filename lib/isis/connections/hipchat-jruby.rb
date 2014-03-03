# encoding: utf-8
# HipChat-JRuby connection
# Uses HipChat's XMPP connection
# Also uses HipChat API for HTML sending

require 'smackr'
require 'isis/connections/hipchat'

class Isis::Connections::HipChatJRuby < Isis::Connections::HipChat

  def initialize(config)
    load_config(config)
    create_jabber
    create_api
  end

  def connect
    @client.connect!
    @join_time = Time.now
  end

  def still_connected?
    @client.xmpp_connection && @client.xmpp_connection.is_connected
  end

  private

  def create_jabber
    # Smackr doesn't take full JID, parse into parts
    username, server = @config['hipchat']['jid'].split('@')
    password = @config['hipchat']['password']
    @client = Smackr.new(server: server, username: username,
                         password: password, resource: 'bot')
  end

  def speak_text(room, message)
    room.xmpp.send_message message
    puts %Q(saying: "#{message}" via XMPP)
  end

  def message_response_callback(packet, xmpp_room)
    speaker = parse_name(packet.from)
    return nil if speaker == @config['hipchat']['name']
    content = packet.body
    room = room_from_jid(xmpp_room.get_room)
    message = Isis::Message.new(content: content, speaker: speaker, room: room)
    puts %Q(MESSAGE: r:#{room.name} s:#{message.speaker} m:#{message.content})
    @plugins.each do |plugin|
      begin
        puts "Sending message to #{plugin}" if ENV['DEBUG']
        response = plugin.receive_message(message, RESPONSE_TYPES)
        speak_response(response, room)
      rescue => e
        puts "ERROR: Plugin #{plugin.class.name} just crashed"
        puts "Message: #{e.message}"
      end
    end
  end

  def parse_name(name)
    name.split('/')[1]
  end

  def participant_callback(packet, room)
    nil
  end

  def joined_callback(name, room)
    @plugins.each do |plugin|
      begin
        speak(room, plugin.joined(name)) if plugin.respond_to?('joined')
      end
    end
  end

  def left_callback(name, room)
    @plugins.each do |plugin|
      begin
        speak(room, plugin.left(name)) if plugin.respond_to?('left')
      end
    end
  end

  class Isis::Connections::HipChat::Room
    def xmpp_join(client, connection)
      @xmpp = client.join_room(@jid, nickname: connection.config['hipchat']['name'])
      @xmpp.message_callback = connection.method(:message_response_callback)
      @xmpp.participant_callback = connection.method(:participant_callback)
      @xmpp.joined_callback = connection.method(:joined_callback)
      @xmpp.left_callback = connection.method(:left_callback)
    end
  end
end
