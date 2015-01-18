module Direction
  class Snapshot
    class << self
      def current
        self.stack.last
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
    end

    def initialize
      @objects = {}
      @object_changes = {}
    end

    attr_reader :object_changes

    def add_object(change, object)
      @objects[change.id] = object
    end

    def find_object(change_id)
      @objects[change_id]
    end

    def changes
      @objects.values
    end

    def run_change(change)
      if change.name == "directionful_new"
        Change.push_new change
      end
      Change.run change do
        case change.type
        when :directive
          puts ":directive send"
          object = change.target.send change.name, *change.args
          self.add_object change, object
          object
        when :delta
          puts ":delta send"
          unless definition = change.target.class.instance_delta(change.name)
            raise "#{change.target.class} has no delta definition for #{change.name}"
          end
          object = change.target.instance_exec *change.args, &definition
          self.add_object change, object
          object
        else
          raise "Invalid type: #{change.type}"
        end
      end
    ensure
      if change.name == "directionful_new"
        Change.pop_new
      end
    end
  end
end
