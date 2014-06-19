module Direction
  class Directive
    attr_reader :subject, :name, :args, :deltas

    def initialize(subject, name, *args)
      @subject = subject
      @name = name
      @args = args
      @deltas = []
    end

    def apply
      subject.send name, *args
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
