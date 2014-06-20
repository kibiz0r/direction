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

  def directive_enact(name, *args)
    # send name, *args
    # unless definition = self.class.instance_directive(name)
    #   raise "No directive definition for #{name}"
    # end
    Direction::Directive.enact self, name, *args
    # directives << directive
    # directive.apply
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
    property_alter name, :set, value
  end

  def property_alter(name, delta_name, *args)
    delta_push :prop_altered, name.to_sym, delta_name, *args
  end

  def property_get(name)
    instance_variable_get :"@#{name}"
    # property_deltas(name).inject nil do |value, delta|
    #   delta = Delta.new delta.name, *delta.args
    #   value.delta_apply delta
    # end
  end

  def property_deltas(name)
    deltas.select do |delta|
      delta.name == :prop_altered &&
        delta.args[0] == name
    end
  end

  def deltas
    @deltas ||= []
  end

  def delta_apply(name, *args)
    unless definition = self.class.instance_delta(name)
      raise "#{self.class} has no delta definition for #{name}"
    end
    instance_exec *args, &definition
  end

  def delta_push(name, *args)
    delta = Direction::Delta.new name, *args
    deltas << delta
    delta_apply name, *args
  end

  # Nope, this ends up being really awkward.
  #
  # Maybe store deltas per property, so that there isn't this implicit protocol
  # hidden in the args of :prop_altered deltas.
  #
  # The other alternative I entertained was including properties in the delta
  # prototype, so a delta could be either :set or [:foo, :set], but that also
  # seems weird.
  #
  # After thinking about it, specifying the property in the prototype seems
  # best. It's sort of like defining a method like foo=. The data is being
  # stored on self, so it makes sense that self gets the chance to define how
  # it is altered.
  delta! :prop_altered do |property_name, delta_name, *args|
    ivar = :"@#{property_name}"
    value = instance_variable_get ivar
    new_value = value.delta_apply delta_name, *args
    instance_variable_set ivar, new_value
  end

  delta :set do |value|
    value
  end

  [
    :+,
    :-,
    :*,
    :/,
    :%,
    :<<
  ].each do |operator|
    delta operator do |value|
      self.send operator, value
    end
  end
end
