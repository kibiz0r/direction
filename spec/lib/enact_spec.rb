require "spec_helper"

describe "enact" do
  describe "directive :my_method => :resulting_delta do |arg1, arg2|" do
    let :my_class do
      Class.new do
        attr_reader :state

        directive :my_method => :resulting_delta do |arg1, arg2|
          @state = arg1
          "arg2: #{arg2}"
        end
      end
    end

    it "applies :resulting_delta and returns it in a directive" do
      directive = enact(subject).my_method 1, 2
      expect(directive).to eq(Directive.new(subject, :my_method, 1, 2))
      expect(delta_set.return_value).to eq(2)
      expect(subject.state).to eq(1)
      expect(delta_set.deltas).to eq([Delta.new(:resulting_delta, 1, 2)])
    end
  end
end
