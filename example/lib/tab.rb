class Tab
  prop_accessor :ordered_items, :served_items

  def initialize(table_number, waiter)
    self.ordered_items = []
    self.served_items = []
  end

  def outstanding_items
    ordered_items.reject do |tab_item|
      served_items.include? tab_item
    end
  end

  directive :place_order => :order_placed do |*items|
    items.map.with_index do |item, index|
      TabItem.new(item, ordered_items.size + index).tap do |tab_item|
        alter.ordered_items << tab_item
      end
    end
  end
  # Equivalent to:
  # def place_order(*items)
  #   alter.order_placed *items
  # end
  #
  # delta! :order_placed do |*items|
  #   items.map.with_index do |item, index|
  #     TabItem.new(item, ordered_items.size + index).tap do |tab_item|
  #       alter.ordered_items << tab_item
  #     end
  #   end
  # end

  # Maybe we could support something like this too?
  # (i.e. prop_delta/prop_delta!)
  #
  # prop_delta :ordered_items, :<< do |*items|
  # end
end
