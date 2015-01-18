class Object
  include Direction

  def object_history
    object_history = Direction::ObjectHistory.new self
    define_singleton_method :object_history do
      object_history
    end
    object_history
  end

  def alter(subject = self)
    Direction::AlterSubject.new subject
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

  def delta_push(property, name, *args)
    puts "delta_push"

    change = Change.new self,
      property,
      :delta,
      name,
      *args

    Timeline.commit change

    delta = Direction::Delta.new change
    # delta.in_progress = true
    # delta.target = self
    # delta.parent = Timeline.head
    # delta.value = delta_apply prototype, *args
    # delta.in_progress = false

    delta
  end

  def delta_invoke(name, *args)
    unless definition = self.class.instance_delta(name)
      raise "#{self.class} has no delta definition for #{name}"
    end
    self.instance_exec *args, &definition
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

  def enact(subject = self)
    Direction::EnactSubject.new subject
  end

  def enact!(subject = self)
    Direction::EnactValueSubject.new subject
  end

  def resolve_target(target)
    # unless known_target? target
    #   raise TimelineError, "Object #{target.inspect} is unknown to this timeline (#{self.inspect})"
    # end
    if target.is_a? Property
      target.value
    else
      target
    end
  end

  def resolve_subject(target)
    # unless known_target? target
    #   raise TimelineError, "Object #{target.inspect} is unknown to this timeline (#{self.inspect})"
    # end
    if target.is_a? Property
      target.subject
    else
      target
    end
  end

  def directive_push(name, *args)
    if name.to_s == "new"
      name = "directionful_new"
    end

    change = Change.new self,
      nil,
      :directive,
      name,
      *args

    Timeline.commit change

    directive = Direction::Directive.new change

    # if self.is_a? Property
    #   directive.property_name = self.name
    # end

    # directive.parent = Timeline.head
    # directive.initiator = resolved_subject

    # directive.value = resolved_target.send name, *args

    directive
  end

  def directive_enact(name, *args)
    # resolved_target = resolve_target self
    resolved_target = self
    resolved_subject = resolve_subject self

    directive = Direction::Directive.new resolved_target, name, *args

    if name.to_s == "new"
      name = "directionful_new"
    end

    if self.is_a? Property
      directive.property_name = self.name
    end

    directive.parent = Timeline.head
    directive.initiator = resolved_subject

    Timeline.commit directive

    directive.value = resolved_target.send name, *args

    directive
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
    delta = delta_push name.to_sym, delta_name, *args
    # property = instance_variable_get :"@#{name}"
    # property.value = delta.value
    delta
  end

  def to_timeline_object
    puts "to_timeline_object: #{self}"
    p Timeline.current.object_graph
    change = Timeline.current.object_changes[self]
    if change.nil? && Change.current_new?
      change = Change.current_new
      Timeline.current.object_graph[change.id] = self
    end
    TimelineObject.new :object, change.id
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
