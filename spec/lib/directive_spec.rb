require "spec_helper"

describe "directive" do
  describe "directive :my_directive => :resulting_delta do |arg1, |arg2|" do
    let :my_class do
      Class.new do
        directive :my_method => :resulting_delta do |arg1, arg2|
          arg1 + arg2
        end
      end
    end

    subject do
      my_class.new
    end

    it "defines an impure delta :resulting_delta with the given body" do
      return_value = subject.delta_apply :resulting_delta
      expect(return_value).to eq(11)
    end

    it "defines a method :my_directive that pushes :resulting_delta and returns the result" do
      return_value = subject.my_method 7, 4
      expect(return_value).to eq(11)
    end
  end
end
