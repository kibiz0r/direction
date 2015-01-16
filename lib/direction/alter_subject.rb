module Direction
  class AlterSubject < BasicObject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args)
      method = method.to_s

      if method.end_with? "="
        property_name = method.chomp "="
        prototype = [property_name, :set]
      else
        prototype = method
      end

      if @subject.applies_delta? prototype
        @subject.delta_push prototype, *args
      elsif @subject.respond_to? method
        if method.end_with? "="
          ::Kernel.raise "No delta #{prototype} on #@subject"
        else
          AlterProperty.new @subject, method
        end
      else
        ::Kernel.raise "No delta #{prototype} or method #{method} on #@subject"
      end
    end
  end
end
