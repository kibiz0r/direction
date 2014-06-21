module Direction
  class AlterProperty
    def initialize(subject, property_name)
      @subject = subject
      @property_name = property_name
    end

    def method_missing(method, *args)
      prototype = [@property_name, method]

      if @subject.applies_delta? prototype
        @subject.delta_push prototype, *args
      else
        raise "No delta #{prototype} on #@subject"
      end
    end
  end
end
