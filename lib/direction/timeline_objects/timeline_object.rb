module Direction
  class TimelineObject
    attr_reader :introducing_change

    def initialize(introducing_change)
      @introducing_change = introducing_change
    end

    def key
      [:object, introducing_change.id]
    end

    def to_s
      "TimelineObject(#{introducing_change})"
    end

    def ==(other)
      other.is_a?(TimelineObject) &&
        self.introducing_change == other.introducing_change
    end

    alias :eql? :==
  end
end
