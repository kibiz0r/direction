module Direction
  class TimeframeChange
    attr_reader :type, :subject, :name, :args

    def initialize(type, subject, name, *args)
      @type = type
      @subject = subject
      @name = name
      @args = args
    end

    def to_s
      "TimeframeChange: (#{type}) #{subject}.#{name} #{args}"
    end
  end
end
