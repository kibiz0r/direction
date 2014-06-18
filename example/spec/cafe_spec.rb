require "spec_helper"

describe Cafe do
  describe "enact:open_tab" do
    it "creates a new tab" do
      tab = enact(subject).open_tab 2, "Kevin"
      expect(tab).to be_an_instance_of(Tab)
    end
  end
end
