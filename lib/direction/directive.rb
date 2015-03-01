module Direction
  class Directive
    attr_reader :timeframe, :previous, :subject, :name, :args, :value

    def initialize(timeframe, previous, subject, name, *args)
      @timeframe = timeframe
      @previous = previous
      @subject = subject
      @name = name
      @args = args
    end

    def value
      Timeframe.directive_value self
    end

    def run(timeframe)
      timeframe.run state do
        subject.send name, *args
      end
    end
  end
end
