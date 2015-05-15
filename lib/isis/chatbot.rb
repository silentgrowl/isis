## Chatbot

require 'yaml'
require 'tzinfo'
require 'singleton'
require 'isis/plugins'
require 'isis/connections'
require 'isis/message'

module Isis
  class Chatbot
    attr_accessor :config, :connection, :plugins, :hello_messages, :timezone

    def initialize
      load_config
      load_plugins
      create_connection
      register_plugins
    end

    # Recreate connection with no history loading, so we don't load any
    # messages that may have triggered the exception
    def recover_from_exception
      @disable_history = true
      create_connection
    end

    def connect
      @connection.connect
    end

    def reconnect
      @connection.reconnect
    end

    def join
      @connection.join
      EventMachine::Timer.new(1) do
        say_hello_messages
      end
      rescue => e
        puts "## EXCEPTION in Chatbot join: #{e.message}"
        recover_from_exception
    end

    # Allow plugin to hook in and set @hello_messages
    # Only do the default 'hello' message if no plugins have set hello messages
    def say_hello_messages
      nil
      # @hello_messages.push @config['hello'] if @hello_messages.empty?
      # @hello_messages.each do |hm|
      #   puts "saying hello message: #{hm}"
      #   speak hm
      # end
    end

    def speak(message)
      @connection.yell message
      rescue => e
        puts "## EXCEPTION in Chatbot speak: #{e.message}"
        recover_from_exception
    end

    def register_plugins
      @connection.register_plugins(@plugins)
    end

    def timer_response
      @connection.timer_response
    end

    def still_connected?
      @connection.still_connected?
    end

    def trap_signals
      [:INT, :TERM].each do |sig|
        trap(sig) do
          puts "Trapped signal #{sig.to_s}"
          puts 'Shutting down gracefully'
          # speak @config['goodbye']
          EventMachine::Timer.new(1) { EventMachine.stop_event_loop }
        end
      end
    end

    def run
      connect
      trap_signals
      join

      # am I still connected, bro? Check every 5 seconds
      EventMachine.add_periodic_timer(5) do
        unless still_connected?
          puts 'Disconnected! Reconnecting...'
          reconnect
          trap_signals
          join
        end
      end

      # Time-based plugin timer
      EventMachine.add_periodic_timer(5) do
        timer_response
      end
    end

    private

    def load_config
      config_file = File.join(ROOT_FOLDER, 'config', 'isis.yml')
      raise 'Isis config isis.yml file not found' unless File.exists?(config_file)
      @config = YAML.load(File.read(config_file))
      check_config
      @timezone = TZInfo::Timezone.get(@config['timezone'])
    end

    def load_plugins
      @plugins = []
      puts "Plugins: #{Isis::Plugin::Base.descendents}" if ENV['DEBUG']
      Isis::Plugin::Base.descendents.each do |plugin|
        begin
          puts "Loading #{plugin}" if ENV['DEBUG']
          plugin_instance = plugin.new(self)
          @plugins << plugin_instance
        rescue Isis::Plugin::PluginSetupError => e
          puts %Q(Error loading plugin "#{plugin}": #{e})
        end
      end
    end

    # Check config object for required values
    def check_config
      raise 'Timezone missing from config.yml' unless @config['timezone']
    end

    def create_connection
      @hello_messages = []
      @connection = case @config['service']
                    when 'slack'
                      Isis::Connections::Slack.new(config)
                    when 'hipchat'
                      if RUBY_PLATFORM =~ /java/
                        Isis::Connections::HipChatJRuby.new(config)
                      else
                        Isis::Connections::HipChatMRI.new(config)
                      end
                    when 'campfire'
                      Isis::Connections::Campfire.new(config)
                    else
                      raise 'Invalid service - please check your config.yml'
                    end
    end
  end
end
