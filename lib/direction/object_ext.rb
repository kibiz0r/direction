class Object
  def alter(subject = self)
    alter_subject = Direction::AlterSubject.new subject
    if block_given?
      yield alter_subject
      nil
    else
      alter_subject
    end
  end

  def applies_delta?(prototype)
    if prototype.is_a? Array
      method = prototype[0]
      self.respond_to? method
    else
      name = prototype
      self.class.delta_defined? name
    end
  end

  def deltas
    @deltas ||= []
  end

  def delta_push(prototype, *args)
    delta = Direction::Delta.new prototype, *args
    deltas << delta
    delta_apply prototype, *args
  end

  def delta_apply(prototype, *args)
    if prototype.is_a? Array
      method = prototype[0]
      subject = send method
      name = prototype[1]
    else
      subject = self
      name = prototype
    end

    unless definition = subject.class.instance_delta(name)
      raise "#{subject.class} has no delta definition for #{name}"
    end
    subject.instance_exec *args, &definition
  end

  # def enact(subject = self)
  #   Direction::EnactSubject.new subject
  # end

  # def directive_enact(name, *args)
  #   # send name, *args
  #   # unless definition = self.class.instance_directive(name)
  #   #   raise "No directive definition for #{name}"
  #   # end
  #   Direction::Directive.enact self, name, *args
  #   # directives << directive
  #   # directive.apply
  # end

  # def directives
  #   @directives ||= []
  # end

  # def properties
  #   @properties ||= {}
  # end

  # def property(name)
  #   name = name.to_sym
  #   properties[name] ||= Direction::Property.new(self, name)
  # end

  # def property_set(name, value)
  #   property_alter name, :set, value
  # end

  # def property_alter(name, delta_name, *args)
  #   delta_push [name.to_sym, delta_name], *args
  # end

  # def property_get(name)
  #   instance_variable_get :"@#{name}"
  #   # property_deltas(name).inject nil do |value, delta|
  #   #   delta = Delta.new delta.name, *delta.args
  #   #   value.delta_apply delta
  #   # end
  # end

  # def property_deltas(name)
  #   deltas.select do |delta|
  #     delta.property == name
  #   end
  # end

  # delta :set do |value|
  #   value
  # end

  # [
  #   :+,
  #   :-,
  #   :*,
  #   :/,
  #   :%,
  #   :<<
  # ].each do |operator|
  #   delta operator do |value|
  #     self.send operator, value
  #   end
  # end
end
