module Direction
  class Delta
    attr_reader :name, :args

    def initialize(name, *args)
      @name = name
      @args = args
    end

    def ==(other)
      other.is_a?(Delta) &&
        self.name == other.name &&
        self.args == other.args
    end
  end
end
