module Direction
  class Property
    attr_reader :subject, :name

    def initialize(subject, name)
      @subject = subject
      @name = name
    end

    def to_s
      "Property##{object_id}(#{subject}, #{name})"
    end

    def value
      puts "Property#value"
      Timeframe.property_value self
    end

    def set(value)
      Director.alter_object(Timeframe.current, self, :set, value).value
    end

    # def send_delta(name, *args)
    #   unless definition = value.class.instance_delta(name)
    #     raise "#{value.class} has no delta definition for #{name}"
    #   end
    #   @value = value.instance_exec *args, &definition
    # end
  end
end
