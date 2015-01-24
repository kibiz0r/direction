class Object
  def send_delta(name, *args)
    unless definition = self.class.instance_delta(name)
      raise "#{self.class} has no delta definition for #{name}"
    end
    instance_exec *args, &definition
  end
end
