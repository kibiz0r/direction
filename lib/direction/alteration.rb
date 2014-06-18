module Direction
  class Alteration
    def initialize(subject, definition)
      @subject = subject
      @definition = definition
    end

    def apply(value, *args)
      @subject.instance_exec value, *args, &@definition.body
    end
  end
end
