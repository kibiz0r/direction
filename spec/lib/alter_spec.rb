require "spec_helper"

describe "alter" do
  describe ".my_impure_delta" do
    let :my_class do
      Class.new do
        attr_reader :my_attr

        delta! :my_impure_delta do |arg|
          @my_attr = arg
        end
      end
    end

    subject do
      my_class.new
    end

    it "pushes :my_impure_delta onto subject" do
      alter(subject).my_impure_delta :modified
      expect(subject.deltas).to eq [
        Delta.new(:my_impure_delta, :modified)
      ]
    end
  end

  describe ".my_impure_delta=" do
    # Not sure yet...
  end

  describe ".my_pure_delta" do
    let :my_class do
      Class.new do
        attr_reader :my_attr

        delta :my_pure_delta do
          raise "shouldn't be allowed"
        end
      end
    end

    subject do
      my_class.new
    end

    it "can't be called without a subject to store it on" do
      alter(subject).my_pure_delta
    end
  end

  describe ".my_pure_delta=" do
    # Not sure yet...
  end

  describe ".my_property.my_pure_delta" do
    let :my_class do
      Class.new do
        attr_accessor :my_property
      end
    end

    let :my_value_type do
      Class.new do
        delta :my_pure_delta do
          :a_new_value
        end
      end
    end

    subject do
      my_class.new.tap do |s|
        s.my_property = my_value_type.new
      end
    end

    it "pushes [:my_property, :my_pure_delta] onto subject" do
      alter(subject).my_property.my_pure_delta
      expect(subject.deltas).to eq [
        Delta.new([:my_property, :my_pure_delta])
      ]
    end
  end

  describe ".my_property.my_pure_delta=" do
    # Not sure yet...
  end

  describe ".my_property.my_impure_delta" do
    # I'm not sure about this yet...
    #
    # it "pushes [:my_property, :my_impure_delta] onto subject" do
    # end
    #
    # or...
    #
    # it "pushes :my_impure_delta onto my_property" do
    # end
    #
    # I guess the question is what makes...
    #   alter.my_property.my_impure_delta
    # ...different from...
    #   alter(my_property).my_impure_delta
    # ...and I guess that means it must be pushed onto subject.
  end

  describe ".my_property.my_impure_delta=" do
    # Not sure about this either...
  end

  # I'm not sure about this whole "intercepting properties" business...
  #
  # describe ".my_intercepted_property.my_property_delta" do
  #   let :my_class do
  #     Class.new do
  #       delta :my_intercepted_property, :my_property_delta do |to_add|
  #         5 + to_add
  #       end
  #   
  #       def my_intercepted_property=(value)
  #         expect(value).to eq(13)
  #       end
  #     end
  #   end

  #   subject do
  #     my_class.new
  #   end

  #   it "pushes [:my_intercepted_property, :my_property_delta] onto subject" do
  #     alter(subject).my_intercepted_property.my_property_delta 8
  #     expect(subject.deltas).to eq [
  #       Delta.new([:my_intercepted_property, :my_property_delta], 8)
  #     ]
  #   end
  # end

  # describe ".my_intercepted_property.my_property_delta=" do
  # end

  # describe ".my_intercepted_property.my_impure_property_delta" do
  # end

  # describe ".my_intercepted_property.my_impure_property_delta=" do
  # end
end
