require "spec_helper"

describe "extrapolate" do
  describe "directive :my_directive => :resulting_delta do |arg1, arg2|" do
    it "returns an un-enacted delta set that, when pushed, will call my_directive" do
    end
  end

  describe "def my_method(arg)" do
    it "returns an un-enacted delta set that, when pushed, will call my_method" do
    end
  end

  describe "delta :my_delta do" do
    it "returns an un-enacted delta set that, when pushed, will apply my_delta" do
    end
  end
end
