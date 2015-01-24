module Direction
  class Alter < BasicObject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args)
      method = method.to_s
      setter = method.end_with? "="
      getter = !setter && args.empty?
      name = method.chomp "="

      if getter && property = @subject.property_get(name)
        Alter.new property
      elsif setter && property = @subject.property_get(name)
        Director.alter_object Timeframe.current, property, :set, *args
      else
        Director.alter_object Timeframe.current, @subject, name, *args
      end
    end
  end

  class AlterValue < BasicObject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args)
      method = method.to_s
      setter = method.end_with? "="
      getter = !setter && args.empty?
      name = method.chomp "="

      if getter && property = @subject.property_get(name)
        AlterValue.new property
      elsif setter && property = @subject.property_get(name)
        Director.alter_object(Timeframe.current, property, :set, *args).value
      else
        Director.alter_object(Timeframe.current, @subject, name, *args).value
      end
    end
  end
end

class Object
  private

  def alter(subject = self)
    ::Direction::Alter.new subject
  end

  def alter!(subject = self)
    ::Direction::AlterValue.new subject
  end
end  
