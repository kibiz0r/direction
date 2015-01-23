module Direction
  class TimelineObject
    attr_reader :introducing_change

    def initialize(introducing_change)
      @introducing_change = introducing_change
    end

    def key
      [:object, introducing_change.id]
    end
  end
end
