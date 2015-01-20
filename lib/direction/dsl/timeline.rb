module Direction
  class Timeline
    class << self
      alias_method :new, :directionless_new
    end
  end
end

