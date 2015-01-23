module Direction
  class Directive
    attr_reader :change

    def initialize(change)
      @change = change
    end

    def value
      Director.directive_value self
    end
  end
end
