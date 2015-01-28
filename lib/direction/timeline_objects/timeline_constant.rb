module Direction
  class TimelineConstant
    attr_reader :name

    def initialize(name)
      @name = name.to_sym
    end

    def to_s
      "TimelineConstant(#{name})"
    end

    def ==(other)
      other.is_a?(TimelineConstant) &&
        self.name == other.name
    end

    alias :eql? :==
  end
end
