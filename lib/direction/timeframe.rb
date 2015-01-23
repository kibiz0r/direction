module Direction
  class Timeframe
    attr_reader :parent, :changes, :properties
    attr_accessor :return_value

    def initialize(parent)
      @parent = parent
      if parent
        @changes = parent.changes.dup
        @properties = parent.properties.dup
      else
        @changes = {}
        @properties = {}
      end
    end

    def merge!(timeframe)
      @changes.merge! timeframe.changes
      @properties.merge! timeframe.properties
    end

    def run(&block)
      timeframe = Timeframe.new self
      Timeframe.push timeframe
      begin
        timeframe.return_value = yield timeframe
      ensure
        Timeframe.pop
      end
      timeframe
    end
    
    # def realize(change)?
    def commit(change)
      key = change.key
      if @changes.has_key? key
        @changes[key]
      else
        timeframe_change = Director.timeframe_change self, change
        @changes[key] = timeframe_change
        timeframe_change
      end
    end

    def change(change_type, subject, name, *args)
      commit Timeline.change(change_type, subject, name, *args)
    end

    def [](timeline_object)
      key = timeline_object.key
      if @changes.has_key? key
        @changes[key]
      else
        @changes[key] = Director.to_timeframe_object self, timeline_object
      end
    end

    class << self
      def current
        stack.last
      end

      def push(timeframe)
        stack.push timeframe
      end

      def pop
        stack.pop
      end

      def stack
        @stack ||= []
      end

      def run(&block)
        current.run &block
      end

      def change(change_type, subject, name, *args)
        current.change change_type, subject, name, *args
      end
    end
  end
end
