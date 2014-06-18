class Object
  def enact(subject = self)
    Direction::EnactSubject.new subject
  end

  def alter(subject = self)
    alter_subject = Direction::AlterSubject.new subject
    if block_given?
      yield alter_subject
      nil
    else
      alter_subject
    end
  end

  def enact_directive(name, *args)
    unless definition = self.class.instance_directive(name)
      raise "No directive definition for #{name}"
    end
    directive = Direction::Directive.new self, definition, *args
    directives << directive
    directive.apply
  end

  def directives
    @directives ||= []
  end

  def properties
    @properties ||= {}
  end

  def property(name)
    name = name.to_sym
    properties[name] ||= Direction::Property.new(self, name)
  end

  def property_set(name, value)
    # Equivalent to:
    #   property_alter name, :set, value
    property(name).set value
  end

  def property_alter(name, method, *args)
    property(name).alter method, *args
  end

  def property_get(name)
    property(name).value
  end
end
