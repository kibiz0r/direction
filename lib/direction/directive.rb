module Direction
  class Directive
    attr_reader :change

    def initialize(change)
      @change = change
    end

    def value
      @change.value
    end
  end
end
