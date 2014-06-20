module Direction
  class AlterSubject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args, &block)
      method = method.to_s
      property_name = method.chomp "="

      if property = @subject.property(property_name)
        if method.end_with? "="
          @subject.property_set property_name, *args
        else
          AlterProperty.new @subject, property_name
        end
      else
        @subject.delta_push method, *args
      end
    end
  end
end
