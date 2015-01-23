module Direction
  class Timeframe
    attr_reader :parent, :objects
    attr_accessor :return_value

    def initialize(parent)
      @parent = parent
      @objects = {}
    end

    def run(&block)
      timeframe = Timeframe.new self
      Timeframe.push timeframe
      begin
        return_value = yield timeframe
        timeframe.return_value = return_value
      ensure
        Timeframe.pop
      end
      timeframe
    end
    
    # def realize(change)?
    def commit(change)
      timeframe_change = Director.timeframe_change self, change
      @objects[change] = timeframe_change
      timeframe_change
    end

    def [](timeline_object)
      key = timeline_object.key
      if @objects.has_key? key
        @objects[key]
      else
        @objects[key] = Director.to_timeframe_object self, timeline_object
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
    end
  end
end
