require 'spec_helper'

describe "Converters" do

  before(:each) do
  end

  describe "BooleanConverter" do

    it "should return true when value is 'true'"
    it "should return true when value is 'True'"
    it "should return false when value is not 'true'"
    it "should return false when value is nil"
    
  end
  
  describe "ArrayConverter" do
    it "should convert a '\\n' separated string to an array"
    it "should convert blank string to empty array"
  end
  
  describe "DateConverter" do
    it "should parse the date from a string"
    it "should return nil if there is no date to parse"
  end

end
