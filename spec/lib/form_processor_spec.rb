require 'spec_helper'

describe "FormProcessor" do

  before(:each) do
  end

  describe "initialize" do

    it "should work with empty values"
    it "should assign options to class variables"

  end

  describe "convert!" do

    it "should convert all registered fields"
    it "should return original data if there are no convertors"

  end

  describe "remap" do

    it "should remap keys specified in @mapping"

    it "should remove keys specified in @field_ids_to_ignore"

  end

end
