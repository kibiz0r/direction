module Direction
  class Delta
    attr_reader :subject, :name, :args

    def initialize(subject, name, *args)
      @subject = subject
      @name = name
      @args = args
    end

    def ==(other)
      other.is_a?(Delta) &&
        self.subject == other.subject &&
        self.name == other.name &&
        self.args == other.args
    end
  end
end
