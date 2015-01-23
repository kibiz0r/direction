module Direction
  class Delta
    attr_reader :change

    def initialize(change)
      @change = change
    end

    def value
      Director.delta_value self
    end
  end
end
