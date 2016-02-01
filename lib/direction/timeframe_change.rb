module Direction
  class TimeframeChange
    attr_accessor :return_value
    attr_reader :modifications

    def initialize
      @modifications = []
    end

    def change
      @modifications << TimeframeChange.new
    end

    def effect
      @modifications << TimeframeEffect.new
    end

    def changes
      modifications.select { |m| m.is_a? TimeframeChange }
    end

    def effects
      modifications.select { |m| m.is_a? TimeframeEffect }
    end
  end
end
