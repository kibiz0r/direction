module Direction
  class EnactSubject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args)
      @subject.directive_push method, *args
      # @subject.directive_enact method, *args
    end
  end

  class EnactValueSubject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args)
      @subject.directive_push(method, *args).value
      # @subject.directive_enact(method, *args).value
    end
  end
end
