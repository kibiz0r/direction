module Direction
  class Enact < BasicObject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args)
      method = method.to_s
      setter = method.end_with? "="
      getter = !setter && args.empty?
      name = method.chomp "="

      if getter && property = Director.find_property(@subject, name)
        Enact.new property
      else
        Director.enact_directive @subject, method, *args
      end
    end
  end

  class EnactValue < BasicObject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args)
      method = method.to_s
      setter = method.end_with? "="
      getter = !setter && args.empty?
      name = method.chomp "="

      if getter && property = Director.find_property(@subject, name)
        EnactValue.new property
      else
        Director.enact_directive(@subject, method, *args).value
      end
    end
  end
end

class Object
  private

  def enact(subject = self)
    ::Direction::Enact.new subject
  end

  def enact!(subject = self)
    ::Direction::EnactValue.new subject
  end
end
