module Direction
  class EnactSubject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args, &block)
      @subject.enact_directive method, *args
    end
  end
end
