module Direction
  class EnactSubject
    def initialize(timeline, subject)
      @timeline = timeline
      @subject = subject
    end

    def method_missing(method, *args)
      @subject.directive_enact @timeline, method, *args
    end
  end
end
