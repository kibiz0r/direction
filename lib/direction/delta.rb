module Direction
  class Delta
    attr_reader :prototype, :args
    attr_accessor :value, :target, :in_progress, :parent

    def initialize(prototype, *args)
      if prototype.is_a? Array
        prototype = prototype.map &:to_sym
      else
        prototype = prototype.to_sym
      end
      @prototype = prototype
      @args = args
    end

    def dup
      self
    end

    def id
      self.object_id
    end

    def initiator
      self.target
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
