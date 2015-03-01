module Direction
  class HistoryChange
    attr_reader :parent, :subject, :name, :args

    def initialize(parent_id, subject, name, *args)
      @parent = parent_id
      @subject = subject
      @name = name
      @args = args
    end

    def to_s
      "Change: (#{parent}) #{subject}.#{name} #{args}"
    end

    def ==(other)
      other.is_a?(Change) &&
        self.parent == other.parent &&
        self.subject == other.subject &&
        self.name == other.name &&
        self.args == other.args
    end

    alias :eql? :==
  end
end

