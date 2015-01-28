module Direction
  class TimeframeState
    attr_reader :objects

    def initialize(objects = {})
      @objects = objects
    end

    def []=(key, value)
      set = @objects
      key.each do |id|
      end
      nil
    end

    def [](key)
      nil
    end

    def dup
      TimeframeState.new @objects.dup
    end
  end
end
