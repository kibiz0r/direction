module Direction
  module DSL
    class AlterSubject < BasicObject
      def initialize(subject)
        @subject = subject
      end

      def method_missing(method, *args)
        ::Kernel.puts method
        method = method.to_s

        if method.end_with? "="
          property_name = method.chomp "="
          property = Timeframe.property_of @subject, property_name
          if Timeframe.has_delta? property, :set
            Timeframe.alter_object property, :set, *args
          else
            ::Kernel.raise "No property #{property_name} on #{@subject}"
          end
        elsif Timeframe.has_property? @subject, method
          AlterProperty.new @subject, method
        else
          ::Kernel.raise "No property or method #{method} on #@subject"
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

        property = Timeframe.property_of(@subject, @property_name)

        if Timeframe.has_delta? property, method
          Timeframe.alter_object property, method, *args
        else
          ::Kernel.raise "No delta #{method} on #{property}"
        end
      end
    end

    module Alter
      private

      def alter(subject = self)
        Direction::DSL::AlterSubject.new subject
      end

      def alter!(subject = self)
        Direction::DSL::AlterValueSubject.new subject
      end
    end
  end
end
