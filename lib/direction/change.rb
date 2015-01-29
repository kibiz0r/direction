module Direction
  class Change
    attr_reader :previous, :type, :subject, :name, :args

    def initialize(previous, type, subject, name, *args)
      @previous = previous
      @type = type
      @subject = subject
      @name = name
      @args = args
    end

    def id
      object_id
    end

    def key
      [:change, id]
    end

    def to_s
      "Change: (#{type}) #{subject}.#{name} #{args}"
    end

    def ==(other)
      other.is_a?(Change) &&
        self.previous == other.previous &&
        self.type == other.type &&
        self.subject == other.subject &&
        self.name == other.name &&
        self.args == other.args
    end

    alias :eql? :==
  end
end
