module Direction
  class EnactSubject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args, &block)
      @subject.directive_enact method, *args
    end
  end
end
