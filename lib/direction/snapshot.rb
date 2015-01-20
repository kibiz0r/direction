module Direction
  class Snapshot
    class << self
      def current
        self.stack.last || Timeline.root_snapshot
      end

      def current?
        !self.current.nil?
      end

      def stack
        @stack ||= []
      end

      def push(snapshot)
        self.stack.push snapshot
      end

      def pop
        self.stack.pop
      end

      def run(snapshot)
        self.push snapshot
        yield if block_given?
      ensure
        self.pop
      end

      def enact(subject, property_name, method, *args)
        self.current.enact subject, property_name, method, *args
      end

      def get_property(subject, property_name)
        self.current.get_property subject, property_name
      end

      def set_property(subject, property_name, value)
        self.current.set_property subject, property_name, value
      end

      def alter_property(subject, property_name, delta_name, *args)
        self.current.alter_property subject, property_name, delta_name, *args
      end

      def has_property?(subject, property_name)
        subject.class.instance_properties.include? property_name.to_sym
      end

      def has_delta?(subject, prototype)
        if prototype.is_a? Array
          method = prototype[0]
          subject.respond_to? method
        else
          name = prototype
          subject.class.delta_defined? name
        end
      end

      def find_change_value(snapshot_change)
        self.current.find_change_value snapshot_change
      end
    end

    def initialize(change_set, &block)
      @change_set = change_set
      self.class.run self, &block
    end

    def properties_of(subject)
      @object_properties ||= {}
      @object_properties[subject] ||= {}
    end

    def enact(subject, property_name, name, *args)
      change = SnapshotChange.new subject,
        property_name,
        :directive,
        name,
        *args

      Directive.new change
    end

    def find_change_value(snapshot_change)
      @change_values ||= {}
      if @change_values.has_key? snapshot_change
        return @change_values[snapshot_change]
      else
        case snapshot_change.type
        when :directive
          value = snapshot_change.subject.send snapshot_change.name,
            *snapshot_change.args
          @change_values[snapshot_change] = value
        when :delta
          current_value = if parent_snapshot
                            parent_snapshot.get_property snapshot_change.subject, snapshot_change.property_name
                          else
                            nil
                          end
          puts "current_value: #{current_value.inspect}"
          value = delta_invoke current_value, snapshot_change.name, *snapshot_change.args
          puts "value: #{value}"
          @change_values[snapshot_change] = value
        else
          raise "Invalid snapshot change type: #{snapshot_change.type}"
        end
      end
    end

    def parent_snapshot
      if @change_set
        parent_change_set = @change_set.parent
        Timeline.find_snapshot parent_change_set
      end
    end

    def get_property(subject, property_name)
      binding.pry
      puts "get_property #{subject}, #{property_name}"
      properties = properties_of subject
      value = if properties.has_key? property_name
        properties[property_name].value
      elsif parent_snapshot
        parent_snapshot.get_property subject, property_name
      else
        nil
      end
      puts "got: #{value.inspect}"
      value
    end

    def set_property(subject, property_name, value)
      puts "set_property #{subject}, #{property_name}, #{value}"
      alter_property subject, property_name, :set, value
    end

    def alter_property(subject, property_name, delta_name, *args)
      puts "alter_property #{subject}, #{property_name}, #{delta_name}, #{args}"
      change = SnapshotChange.new subject,
        property_name,
        :delta,
        delta_name,
        *args

      properties_of(subject)[property_name] = change
      # change.value = value
      change.value

      Delta.new change
    end

    def delta_invoke(subject, delta_name, *args)
      unless definition = subject.class.instance_delta(delta_name)
        raise "#{subject.class} has no delta definition for #{delta_name}"
      end
      subject.instance_exec *args, &definition
    end
  end
end
