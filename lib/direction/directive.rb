module Direction
  class Directive
    attr_reader :change

    def initialize(change)
      @change = change
    end

    def value
      @change.object
    end

    def dup
      self
    end

    def id
      self.object_id
    end

    def target
      if @id
        ObjectSpace._id2ref @id
      elsif @type
        @type
      end
    end

    def deltas
      []
    end

    def apply
      subject.send name, *args
    end

    def ==(other)
      other.is_a?(Directive) &&
        self.name == other.name &&
        self.args == other.args
    end

    def self.enact(subject, name, *args)
      push(subject, name, *args).tap do |directive|
        directive.apply
      end
    ensure
      pop
    end

    def self.push(subject, name, *args)
      new(subject, name, *args).tap do |directive|
        stack.push directive
      end
    end

    def self.pop
      stack.pop
    end

    def self.current
      stack.last || root
    end

    def self.root
      @root ||= Directive.new nil, nil
    end

    def self.stack
      @stack ||= []
    end
  end
end
