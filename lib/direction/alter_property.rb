module Direction
  class AlterProperty
    def initialize(timeline, subject, property_name)
      @timeline = timeline
      @subject = subject
      @property_name = property_name
    end

    def method_missing(method, *args)
      prototype = [@property_name, method]

      if @subject.applies_delta? prototype
        @subject.delta_push timeline, prototype, *args
      else
        raise "No delta #{prototype} on #@subject"
      end
    end
  end
end
