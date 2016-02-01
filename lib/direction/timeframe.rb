module Direction
  class Timeframe
    attr_reader :state

    def initialize(state = {})
      @state = state
    end

    def dup
      Timeframe.new state.dup
    end

    def run
      Timeframe.push self
      return_value = yield self
      Timeframe.pop
      return_value
    end

    def modify(&block)
      timeframe = dup
      return_value = timeframe.run &block
      merge timeframe
      return_value
    end

    def change(&block)
      change = TimeframeChange.new
      @state[change][:return_value] = modify do |timeframe|
        @state[change][:timeframe] = timeframe
        block.call
      end
      change
    end

    def set_property(subject, property, value)
      properties = @state[subject] ||= {}
      properties[property] = value
    end

    def get_property(subject, property)
      properties = @state[subject] ||= {}
      properties[property]
    end

    class << self
      def current
        @stack.last
      end

      def stack
        @stack ||= []
      end

      def push(timeframe)
        stack.push timeframe
      end

      def pop
        stack.pop
      end
    end
  end
end
