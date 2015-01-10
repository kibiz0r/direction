require "spec_helper"

describe "To-Do Example" do
  class ToDoItem
    property :name
    attr_reader :completed

    delta! :completed do
      @completed = true
    end

    def complete
      alter.completed
    end
  end

  describe "completing a to-do item" do
    it "does stuff" do
      to_do_item = ToDoItem.new
      enact(to_do_item).complete
    end
  end
end
