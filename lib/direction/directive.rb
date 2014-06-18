module Direction
  class Directive
    attr_reader :subject, :definition, :args

    def initialize(subject, definition, *args)
      @subject = subject
      @definition = definition
      @args = args
    end

    def apply
      subject.instance_exec *args, &definition.body
    end
  end
end
