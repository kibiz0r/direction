module Direction
  module DSL
    class EnactSubject
      def initialize(subject)
        @subject = subject
      end

      def method_missing(method, *args)
        if Timeframe.has_property? @subject, method and args.empty?
          EnactProperty.new @subject, method
        else
          Timeframe.enact_directive @subject, method, *args
        end
      end
    end

    class EnactProperty
      def initialize(subject, property_name)
        @subject = subject
        @property_name = property_name
      end

      def method_missing(method, *args)
        Timeframe.enact_directive @subject, method, *args
      end
    end

    class EnactValueSubject
      def initialize(subject)
        @subject = subject
      end

      def method_missing(method, *args)
        if Timeframe.has_property? @subject, method and args.empty?
          EnactValueProperty.new @subject, method
        else
          Timeframe.enact_directive(@subject, method, *args).value
        end
      end
    end

    class EnactValueProperty
      def initialize(subject, property_name)
        @subject = subject
        @property_name = property_name
      end

      def method_missing(method, *args)
        Timeframe.enact_directive(@subject, method, *args).value
      end
    end

    module Enact
      private

      def enact(subject = self)
        EnactSubject.new subject
      end

      def enact!(subject = self)
        EnactValueSubject.new subject
      end
    end
  end
end
