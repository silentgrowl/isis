module Isis
  module Connections
    class Base
      attr_accessor :config, :join_time, :plugins

      def load_config(loaded_config)
        @config = loaded_config
      end

      def register_plugins(plugins)
        @plugins = plugins
      end
    end
  end
end
