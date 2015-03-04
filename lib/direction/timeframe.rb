module Direction
  class Timeframe
    attr_reader :focus

    def initialize(focus = nil, snapshot = {})
      @focus = focus
      @snapshot = snapshot
    end

    def change(&block)
      change = TimeframeChange.new
      timeframe = ChangeTimeframe.new change, @snapshot
      if block_given?
        timeframe.run &block
      end
      change
    end

    def effect(&block)
      effect = TimeframeEffect.new
      timeframe = EffectTimeframe.new effect, @snapshot
      if block_given?
        timeframe.run &block
      end
      effect
    end

    def run
      Timeframe.current = self
      focus.return_value = yield self
      Timeframe.current = nil
    end

    def set_property(subject, property, value)
      properties = @snapshot[subject] ||= {}
      properties[property] = value
    end

    def get_property(subject, property)
      properties = @snapshot[subject] ||= {}
      properties[property]
    end

    class << self
      attr_accessor :current
    end
  end
end
