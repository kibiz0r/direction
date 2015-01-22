module Direction
  class ChangeResults
    attr_accessor :value

    def initialize(change)
      @change = change
    end

    def properties_of(subject)
      @object_properties ||= {}
      @object_properties[subject] ||= {}
    end

    def property_of(object, property_name)
      properties = properties_of object
      if properties.has_key? property_name
        properties[property_name]
      else
        properties[property_name] = Property.new object, property_name
      end
    end

    def get_property(subject, property_name)
      puts "get_property #{subject}, #{property_name}"
      properties = properties_of subject
      if properties.has_key? property_name
        puts "has_key"
        properties[property_name]
      elsif previous = @change && @change.previous_change
        previous_results = @change.timeframe.find_caused_results previous
        previous_results.get_property subject, property_name
      end
    end

    def set_property_of(subject, property_name, value)
      puts "set_property #{subject}, #{property_name}, #{value}"
      properties = properties_of subject
      properties[property_name] = value
    end
  end
end
