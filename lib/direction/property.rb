module Direction
  class Property < BasicObject
    attr_reader :subject, :name, :value

    def initialize(subject, name)
      @subject = subject
      @name = name
      @value = nil
    end

    def to_s
      "Property##{__id__}(#{subject}, #{name}): #{value}"
    end

    def method_missing(method, *args)
      value.send method, *args
    end

    def send_delta(name, *args)
      unless definition = value.class.instance_delta(name)
        raise "#{value.class} has no delta definition for #{name}"
      end
      @value = value.instance_exec *args, &definition
    end
  end
end
