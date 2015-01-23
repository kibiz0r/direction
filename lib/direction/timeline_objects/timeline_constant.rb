module Direction
  class TimelineConstant
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def to_s
      "TimelineConstant(#{name})"
    end
  end
end
