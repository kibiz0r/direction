module Direction
  class Property
    attr_reader :deltas

    def initialize(subject, name)
      @subject = subject
      @name = name
      @deltas = []
    end

    def set(value)
      alter :set, value
    end

    def alter(method, *args)
      Delta.new(self, method, *args).tap do |delta|
        @deltas << delta
        Directive.current.deltas << delta
      end
    end

    def value
      deltas.inject nil do |value, delta|
        value.delta_apply delta.name, *delta.args
      end
    end
  end
end
