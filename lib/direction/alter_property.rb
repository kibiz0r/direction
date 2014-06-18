module Direction
  class AlterProperty
    def initialize(subject, property_name)
      @subject = subject
      @property_name = property_name
    end

    def method_missing(method, *args, &block)
      @subject.property_alter @property_name, method, *args
    end
  end
end
