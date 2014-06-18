require "spec_helper"

describe Tab do
  subject do
    Tab.new 2, "Kevin"
  end

  describe "enact:place_order" do
    it "places an order" do
      tab_items = enact(subject).place_order Drink::Coffee
      expect(tab_items.map(&:item)).to eq([Drink::Coffee])
      expect(subject.outstanding_items).to eq(tab_items)
    end
  end
end
