require "spec_helper"

describe "delta" do
  describe "pure" do
    describe "via #delta" do
      it "defines a delta that returns a new value based on self" do
      end

      it "can be implemented in terms of other pure deltas" do
      end

      it "can't be implemented in terms of impure deltas" do
      end
    end
  end

  describe "impure" do
    describe "via #delta!" do
      it "defines a delta that mutates self" do
      end

      it "can be implemented in terms of pure deltas" do
      end

      it "can be implemented in terms of other impure deltas" do
      end
    end
  end
end
