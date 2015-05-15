## Plugin base class
module Isis
  module Plugin
    class PluginSetupError < RuntimeError
    end

    class Base
      def self.descendents
        ObjectSpace.each_object(Class).select { |klass| klass < self }
      end

      def initialize(bot)
        @bot = bot
        setup
      end

      def respond_to_message?(message)
        respond_to_msg?(message.content, message.speaker)
      end

      # Deprecated - update plugins to use respond_to_message? instead
      def respond_to_msg?(msg, speaker)
        nil
      end

      def receive_message(message, types)
        respond_to_message?(message) ? response(types) : nil
      end

      def response(types)
        types.each do |d|
          name = "response_#{d}".to_sym
          if self.respond_to?(name, true)
            opts = { content: self.send(name), type: d }
            return Response.new(opts)
          end
        end
      end

      def content_type(types)
        types.each { |d| return d if self.respond_to?("response_#{d}", true) }
        return 'text'     # default
      end

      def hello_message
        false
      end

      def timer_response(types)
        nil
      end

      class Response
        attr_reader :content, :type
        attr_accessor :room

        def initialize(opts)
          @content = opts[:content] || nil
          @type = opts[:type] || 'text'
          @room = opts[:room] || nil
        end
      end

      private

      # Setup method for overriding in child classes
      def setup
        nil
      end

      # Time helpers
      def now
        @bot.timezone.utc_to_local(Time.new.utc)
      end

      def timestamp
        now.strftime('%l:%M %P').strip
      end

      def zone
        @bot.timezone.strftime('%Z')
      end
    end
  end
end
