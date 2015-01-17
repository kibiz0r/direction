module Direction
  class Property
    attr_reader :subject, :name

    def initialize(subject, name)
      @subject = subject
      @name = name
    end

    def value
      changes = Timeline.changes.select do |change|
        change.is_a? Delta and
          change.property == @name
      end
      changes.last.value
    end
# 
#     def set(value)
#       alter :set, value
#     end
# 
#     def alter(method, *args)
#       Delta.new(self, method, *args).tap do |delta|
#         @deltas << delta
#         Directive.current.deltas << delta
#       end
#     end
# 
#     def value
#       deltas.inject nil do |value, delta|
#         value.delta_apply delta.name, *delta.args
#       end
#     end
# 
#     def delta_apply(method, *args)
#       Delta.new(self, method, *args).tap do |delta|
#         @deltas << delta
#         Directive.current.deltas << delta
#       end
#     end
  end
end
