require "spec_helper"

describe Direction::TimeframeChange do
  describe "#effect" do
    it "creates a TimeframeEffect" do
      effect = subject.effect
      expect(effect).to be_a(Direction::TimeframeEffect)
    end

    it "records the new effect" do
      effect = subject.effect
      expect(subject.effects).to match_array([effect])
    end
  end

  describe "#modifications" do
    it "contains all of the changes and effects that occurred within the change" do
      change1 = subject.change
      effect1 = subject.effect
      effect2 = subject.effect
      change2 = subject.change
      effect3 = subject.effect

      expect(subject.modifications).to match_array([
        change1,
        effect1,
        effect2,
        change2,
        effect3
      ])
    end
  end
end
