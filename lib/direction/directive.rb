module Direction
  class Directive
    attr_reader :timeframe, :change

    def initialize(timeframe, change)
      @timeframe = timeframe
      @change = change
    end

    def value
      Director.directive_value self
    end
  end
end
