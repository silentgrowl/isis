module Isis
  class Message
    attr_reader :content, :speaker, :room

    def initialize(opts)
      @content = opts[:content] || ""
      @speaker = opts[:speaker] || "unknown speaker"
      @room = opts[:room] || nil
    end
  end
end
