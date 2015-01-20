module Direction
  module DSL
    module Enact
      private

      def enact(subject = self)
        Direction::EnactSubject.new subject
      end

      def enact!(subject = self)
        Direction::EnactValueSubject.new subject
      end
    end
  end
end
