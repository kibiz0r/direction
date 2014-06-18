module Direction
  class Delta
    attr_reader :subject, :definition, :args

    def initialize(subject, definition, *args)
      @subject = subject
      @definition = definition
      @args = args
    end

    def apply(value)
      @subject.instance_exec value, *@args, &@definition.body
    end
  end
end
