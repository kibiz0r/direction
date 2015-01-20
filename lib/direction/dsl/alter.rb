module Direction
  module DSL
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
