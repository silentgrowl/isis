# encoding: utf-8
# HipChat connection base class
# Uses HipChat's XMPP connection
# Also uses HipChat API for HTML sending

require 'hipchat'
require 'isis/connections/hipchat'

class Isis::Connections::HipChat < Isis::Connections::Base
  attr_accessor :client, :rooms, :plugins
  RESPONSE_TYPES = %w(html text)

  def join
    join_rooms
  end

  def reconnect
    kill_and_clean_up
    create_jabber
    connect
  end

  def kill_and_clean_up
    @client.close
  end

  def register_disconnect_callback
    @client.on_exception do |e, stream, where|
      puts "Exception! #{e.to_s}"
      self.connect  # Reconnect!
    end
  end

  def timer_response
    @plugins.each do |plugin|
      response = plugin.timer_response(RESPONSE_TYPES)
      speak_response(response)
    end
  end

  private

  def create_api
    @api = HipChat::Client.new(@config['hipchat']['token'])
  end

  def join_rooms
    @rooms = []
    @config['hipchat']['rooms'].each do |jid|
      room = Room.new(jid, @api, @client, self)
      @rooms << room
    end
  end

  def speak_response(response, room = nil)
    unless response.blank?
      room ||= room_from_name(response.room)
      if response.content.respond_to?('each')
        response.content.each { |line| speak(room, line, response.type) }
      else
        speak(room, response.content, response.type)
      end
    end
  end

  def speak(room, message, type = 'text')
    if type == 'html'
      speak_html(room, message)
    else
      speak_text(room, message)
    end
  end

  def speak_html(room, message, color = 'gray')
    @api[room.name].send(@config['hipchat']['name'], message,
                         color: color, message_format: 'html')
    puts %Q(saying: "#{message}" via API)
  end

  def yell(message, type = 'text')
    if type == 'html'
      @rooms.each { |r| speak_html(r, message) }
    else
      @rooms.each { |r| speak_text(r, message) }
    end
  end

  def room_from_name(name)
    @rooms.select { |rm| rm.name == name }.first
  end

  def room_from_jid(jid)
    @rooms.select { |rm| rm.jid == jid }.first
  end

  # Rooms are a combination of XMPP and HipChat info
  # XMPP is used for room presense, and text-only responses (faster)
  # HipChat API is used for HTML responses, color, etc.
  class Room
    attr_accessor :xmpp, :name, :id, :jid
    def initialize(jid, api, client, connection)
      @jid = jid
      @api = api
      hc_info_from_jid(jid)
      xmpp_join(client, connection)
    end

    def hc_info_from_jid(jid)
      @api.rooms.each do |r|
        if r.xmpp_jid == jid
          @name = r.name
          @id = r.room_id
          return
        end
      end
    end

    def xmpp_join(client, connection)
      nil
    end
  end
end
