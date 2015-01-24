module Direction
  class TimeframeObject
    attr_reader :timeframe, :object

    def initialize(timeframe, object)
      @timeframe = timeframe
      @object = object
    end

    def directive(name, *args)
      @object.send name, *args
    end

    def to_s
      "TimeframeObject(#{@object})"
    end
  end
end
