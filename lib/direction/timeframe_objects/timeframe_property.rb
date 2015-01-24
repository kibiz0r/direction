module Direction
  class TimeframeProperty
    attr_reader :timeframe, :property

    def initialize(timeframe, property)
      @timeframe = timeframe
      @property = property
    end

    def directive(name, *args)
      puts "#{self} property directive #{name} on #{@value}"
      @value.send name, *args
    end

    def delta(name, *args)
      puts "#{self} property delta #{name}"
      @value = property.send_delta name, *args
      puts "@value = #{@value}"
      @value
    end
  end
end
