module Direction
  class AlterSubject
    def initialize(timeline, subject)
      @timeline = timeline
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
        @subject.delta_push @timeline, prototype, *args
      elsif @subject.respond_to? method
        if method.end_with? "="
          raise "No delta #{prototype} on #@subject"
        else
          AlterProperty.new @timeline, @subject, method
        end
      else
        raise "No delta #{prototype} or method #{method} on #@subject"
      end
    end
  end
end
