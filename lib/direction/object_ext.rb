class Object
  include Direction

  def timeline
    @timeline ||= Direction::Timeline.new self
  end

  def object_history
    @object_history ||= Direction::ObjectHistory.new self
  end

  def alter(subject = self)
    alter_subject = Direction::AlterSubject.new timeline, subject
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

  def delta_push(timeline, prototype, *args)
    delta = Direction::Delta.new prototype, *args
    delta.target = self
    deltas << delta
    Timeline.changes << delta
    delta.value = delta_apply timeline, prototype, *args
    delta
  end

  def delta_apply(timeline, prototype, *args)
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

  def enact(subject = self)
    timeline.enact subject
  end

  def enact!(subject = self)
    timeline.enact! subject
  end

  def directive_enact(timeline, name, *args)
    timeline.directive_enact self, name, *args
  end

  def property_get(name)
    object_history.property_get name
  end

  # def property_set(name, value)
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

  def property_set(name, value)
    property_alter name, :set, value
  end

  def property_alter(name, delta_name, *args)
    delta = delta_push timeline, [name.to_sym, delta_name], *args
    property = instance_variable_get :"@#{name}"
    property.value = delta.value
    delta
  end

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

  delta :set do |value|
    value
  end

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
