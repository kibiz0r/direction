class Class
  def prop_accessor(*names)
    names.each do |name|
      name = name.to_sym
      ivar = :"@#{name}"
      getter = name
      setter = :"#{name}="

      instance_properties << name

      define_method getter do
        property_get name
      end

      define_method setter do |value|
        instance_variable_set ivar, Property.new(self, name)
        property_set name, value
      end
    end
  end

  def directive(prototype, &body)
    if prototype.is_a? Hash
      name, delta_name = prototype.first
    else
      name = prototype
    end
    name = name.to_sym
    instance_directives[name] = body
    define_method name, &body
  end

  def instance_directive(name)
    name = name.to_sym
    instance_directive = instance_directives[name]

    if instance_directive.nil? && !superclass.nil?
      superclass.instance_directive name
    else
      instance_directive
    end
  end

  def instance_directives
    @instance_directives ||= {}
  end

  def instance_properties
    @instance_properties || []
  end

  # #delta means that you intend to return a new value as the result of the delta.
  # This implies that this delta must be stored on a property.
  def delta(name, &body)
    name = name.to_sym
    instance_deltas[name] = body
  end

  # #delta! means that you intend to mutate self in order to apply the delta.
  # This implies that this delta must be stored on self.
  def delta!(name, &body)
    name = name.to_sym
    instance_deltas[name] = body
  end

  def delta_defined?(name)
    !instance_delta(name).nil?
  end

  def instance_delta(prototype)
    if prototype.is_a? Array
      return nil
    else
      name = prototype
    end
    name = name.to_sym
    instance_delta = instance_deltas[name]

    if instance_delta.nil? && !superclass.nil?
      superclass.instance_delta name
    else
      instance_delta
    end
  end

  def instance_deltas
    @instance_deltas ||= {}
  end
end
