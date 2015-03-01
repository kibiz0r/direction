module Direction
  class BasicChangeSet
    attr_accessor :cause, :effects

    def initialize(cause, effects)
      @cause = cause
      @effects = effects
    end
  end
end
