class Cafe
  prop_accessor :tables

  def initialize
    self.tables = [Table.new, Table.new, Table.new]
  end

  directive :open_tab do |table_number, waiter|
    unless table = tables[table_number - 1]
      raise "No such table: #{table_number}"
    end

    Tab.new(table_number, waiter).tap do |tab|
      # Note that doing this without the alter still works, but it wouldn't be
      # stored as a delta on the tabs property.
      #
      #   tables[table_number].tabs << tab
      alter(tables[table_number]).tabs << tab
    end
  end
end
