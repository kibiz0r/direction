module Direction
  class Delta
    attr_reader :prototype, :args

    def initialize(prototype, *args)
      if prototype.is_a? Array
        prototype = prototype.map &:to_sym
      else
        prototype = prototype.to_sym
      end
      @prototype = prototype
      @args = args
    end

    def property
      if @prototype.is_a? Array
        @prototype[0]
      end
    end

    def name
      if @prototype.is_a? Array
        @prototype[1]
      else
        @prototype
      end
    end

    def ==(other)
      other.is_a?(Delta) &&
        self.prototype == other.prototype &&
        self.args == other.args
    end
  end
end
