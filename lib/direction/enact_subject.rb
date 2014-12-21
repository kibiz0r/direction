module Direction
  class EnactSubject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args)
      Directive.new method, *args
      # @subject.directive_enact method, *args
    end
  end
end
