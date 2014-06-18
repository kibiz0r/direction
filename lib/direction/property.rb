module Direction
  class Property
    attr_reader :deltas

    def initialize(subject, name)
      @subject = subject
      @name = name
      @deltas = []
      @value = nil
    end

    def delta(name, *args)
      unless definition = self.class.instance_delta(name)
        raise "No delta definition for #{name}"
      end
      Delta.new self, definition, *args
    end

    def self.delta(name, &body)
      instance_deltas[name] = DeltaDefinition.new &body
    end

    def self.instance_delta(name)
      instance_deltas[name]
    end

    def self.instance_deltas
      @instance_deltas ||= {}
    end

    delta :+ do |value, to_add|
      value + to_add
    end

    delta :set do |value, new_value|
      new_value
    end

    delta :<< do |value, to_add|
      value << to_add
    end

    def set(value)
      alter :set, value
    end

    def alter(method, *args)
      deltas << delta(method, *args)
    end

    def value
      deltas.inject nil do |value, delta|
        delta.apply value
      end
    end
  end
end
