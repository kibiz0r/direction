module Direction
  class ChangeTimeframe < Timeframe
    def effect(&block)
      effect = super &block
      focus.effects << effect
      effect
    end
  end
end
