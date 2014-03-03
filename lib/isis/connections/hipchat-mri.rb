# HipChat connection
# Uses HipChat's XMPP connection

require 'xmpp4r'
require 'xmpp4r/muc/helper/simplemucclient'
require 'isis/connections/hipchat'

class Isis::Connections::HipChatMRI < Isis::Connections::HipChat

  def initialize(config)
    load_config(config)
    create_jabber
    create_api
  end

  def connect
    @client.connect
    @client.auth(@config['hipchat']['password'])
    send_jabber_presence
    @join_time = Time.now
  end

  def still_connected?
    @client.is_connected?
  end

  def message_response_callback(xmpp_room)
    xmpp_room.on_message do |time, speaker, message|
      unless speaker == @config['hipchat']['name']
        begin
          room = room_from_jid("#{xmpp_room.jid.node}@#{xmpp_room.jid.domain}")
          msg = Isis::Message.new(content: message, speaker: speaker, room: room)
          puts %Q(MESSAGE: r:#{room.name} s:#{msg.speaker} m:#{msg.content})
        rescue => e
          puts "ERROR in message response callback"
          puts "Message: #{e.message}"
        end
        @plugins.each do |plugin|
          begin
            puts "Sending message to #{plugin}" if ENV['DEBUG']
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

  def private_message_callback(xmpp_room)
    xmpp_room.on_private_message do |time, speaker, message|
      puts "private-MESSAGE: s:#{sudo} s:#{speaker} m:#{message}"
    end
  end

  def room_message_callback(xmpp_room)
    xmpp_room.on_room_message do |time, message|
      puts "room-MESSAGE: s:#{sudo} s:#{speaker} m:#{message}"
    end
  end

  private

  def create_jabber
    @client = Jabber::Client.new(@config['hipchat']['jid'])
  end

  def send_jabber_presence
    @client.send(Jabber::Presence.new.set_type(:available))
  end

  def speak_text(room, message)
    room.xmpp.send Jabber::Message.new(room.xmpp.room, message)
    puts %Q(saying: "#{message}" via XMPP)
  end

  class Isis::Connections::HipChat::Room
    def xmpp_join(client, connection)
      @xmpp = Jabber::MUC::SimpleMUCClient.new(client)
      connection.message_response_callback(@xmpp)
      connection.private_message_callback(@xmpp)
      connection.room_message_callback(@xmpp)
      @xmpp.join "#{self.jid}/#{connection.config['hipchat']['name']}",
                 connection.config['hipchat']['password'],
                 history: 0
      rescue => e
        puts "## EXCEPTION in HipChat join: #{e.message}"
    end
  end
end
