require "spec_helper"

describe "Car Example 2" do
  class Car
    property :gas, :odometer

    def gallons_per_mile
      1.0 / 20.0
    end

    directive :drive => :drove do |miles|
      alter.odometer + miles
      alter.gas - (gallons_per_mile * miles)
    end
  end
end
