module Direction
  class Property
    attr_reader :deltas

    def initialize(subject, name)
      @subject = subject
      @name = name
      @deltas = []
      @value = nil
    end

    # directive :set do |value|
    #   @value = value
    # end

    # directive :+ do |value|
    #   @value = @value + value
    # end

    # directive :<< do |value|
    #   puts "directive <<"
    #   puts caller
    #   @value << value
    # end

    def alteration(name)
      unless definition = self.class.instance_alteration(name)
        raise "No alteration definition for #{name}"
      end
      Alteration.new self, definition
    end

    def self.alteration(name, &body)
      instance_alterations[name] = AlterationDefinition.new &body
    end

    def self.instance_alteration(name)
      instance_alterations[name]
    end

    def self.instance_alterations
      @instance_alterations ||= {}
    end

    alteration :set do |value, new_value|
      new_value
    end

    alteration :<< do |value, to_add|
      value << to_add
    end

    def set(value)
      alter :set, value
    end

    def alter(method, *args)
      deltas << Delta.new(method, *args)
    end

    def value
      deltas.inject nil do |value, delta|
        delta.apply self, value
      end
    end
  end
end
