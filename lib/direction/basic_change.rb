module Direction
  class BasicChange
    attr_reader :subject, :name, :args

    def initialize(subject, name, *args)
      @subject = subject
      @name = name
      @args = args
    end

    def to_s
      "BasicChange: #{subject}.#{name} #{args}"
    end

    def ==(other)
      other.is_a?(BasicChange) &&
        self.subject == other.subject &&
        self.name == other.name &&
        self.args == other.args
    end

    alias :eql? :==
  end
end
