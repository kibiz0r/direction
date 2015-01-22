module Direction
  class Directive
    attr_reader :change

    def initialize(change)
      @change = change
    end

    def value
      Timeframe.find_caused_results(@change).value
    end
  end
end
