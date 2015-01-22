module Direction
  class TimeframeObject
    attr_reader :object, :introducing_change

    def initialize(object, introducing_change)
      @object = object
      @introducing_change = introducing_change
    end

    def id
      @introducing_change.id
    end
  end
end
