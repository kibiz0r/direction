module Direction
  module DSL
    class AlterSubject < BasicObject
      def initialize(subject)
        @subject = subject
      end

      def method_missing(method, *args)
        method = method.to_s

        if method.end_with? "="
          property_name = method.chomp "="
          prototype = [property_name, :set]
        else
          prototype = method
        end

        if Snapshot.has_delta? @subject, prototype
          Snapshot.alter_property @subject, property_name, :set, *args
        elsif @subject.respond_to? method
          if method.end_with? "="
            ::Kernel.raise "No delta #{prototype} on #@subject"
          else
            AlterProperty.new @subject, method
          end
        else
          ::Kernel.raise "No delta #{prototype} or method #{method} on #@subject"
        end
      end
    end

    class AlterProperty < BasicObject
      def initialize(subject, property_name)
        @subject = subject
        @property_name = property_name
      end

      def method_missing(method, *args)
        ::Kernel.puts "method_missing #{method}"
        prototype = [@property_name, method]

        if Snapshot.has_delta? @subject, prototype
          Snapshot.alter_property @subject, @property_name, :set, *args
        else
          ::Kernel.raise "No delta #{prototype} on #@subject"
        end
      end
    end
  end
end
