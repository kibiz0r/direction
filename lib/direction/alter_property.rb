module Direction
  class AlterProperty < BasicObject
    def initialize(subject, property_name)
      @subject = subject
      @property_name = property_name
    end

    def method_missing(method, *args)
      prototype = [@property_name, method]

      if @subject.applies_delta? prototype
        @subject.delta_push prototype, *args
      else
        ::Kernel.raise "No delta #{prototype} on #@subject"
      end
    end
  end
end
