module Direction
  class TimelineChange
    def id
      Timeframe.current.get_property self, :id
    end

    def id=(value)
      Timeframe.current.set_property self, :id, value
    end

    def parent
      Timeframe.current.get_property self, :parent
    end

    def parent=(value)
      Timeframe.current.set_property self, :parent, value
    end

    def timeline
      Timeframe.current.get_property self, :timeline
    end

    def timeline=(value)
      Timeframe.current.set_property self, :timeline, value
    end

    def timeframe
      Timeframe.current.get_property self, :timeframe
    end

    def timeframe=(value)
      Timeframe.current.set_property self, :timeframe, value
    end

    def return_value
      Timeframe.current.get_property self, :return_value
    end

    def return_value=(value)
      Timeframe.current.set_property self, :return_value, value
    end
  end
end

