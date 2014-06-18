module Direction
  class AlterSubject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args, &block)
      method = method.to_s
      property_name = method.chomp "="
      if method.end_with? "="
        @subject.property_set property_name, *args
      else
        AlterProperty.new @subject, property_name
      end
    end
  end
end
