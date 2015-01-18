module Direction
  class TimelineProperty
    attr_reader :subject, :property_name

    def initialize(subject, property_name)
      @subject = subject.to_timeline_object
      puts "subject:"
      p @subject
      puts "subject.value:"
      p @subject.value
      puts "/subject.value:"
      @property_name = property_name
    end

    def description
      "#{@subject.description}.#{@property_name}"
    end

    def value
      puts "subject now:"
      p @subject
      puts "subject.value now:"
      p @subject.value
      puts "/subject.value now:"
      @subject.value.send @property_name
    end
  end
end
