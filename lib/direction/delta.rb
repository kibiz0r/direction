module Direction
  class Delta
    attr_reader :timeframe, :change

    def initialize(timeframe, change)
      @timeframe = timeframe
      @change = change
    end

    def value
      Director.delta_value self
    end
  end
end
