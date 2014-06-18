module Direction
  class Delta
    def initialize(method, *args)
      @method = method.to_sym
      @args = args
    end

    def apply(property, value)
      property.alteration(@method).apply value, *@args
    end
  end
end
