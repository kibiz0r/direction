module Direction
  class TimeframeResults
    attr_reader :return_value, :error_thrown, :property_values

    def initialize(return_value, error_thrown, property_values)
      @return_value = return_value
      @error_thrown = error_thrown
      @property_values = property_values
    end
  end
end
