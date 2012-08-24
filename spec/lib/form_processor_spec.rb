require 'spec_helper'
require 'formstack_integration/form_processor'

describe "FormProcessor" do

  before(:each) do
    @fp = FormstackIntegration::FormProcessor
  end

  describe "initialize" do

    it "should work with empty values" do
      fp = @fp.new
      fp.instance_variable_get("@mapping").should == {}
      fp.instance_variable_get("@field_ids_to_ignore").should == []
      fp.instance_variable_get("@converters").should == {}
      fp.instance_variable_get("@root_fields").should == %w(id remote_addr timestamp payment_status)
    end
    
    it "should assign options to class variables" do
      mapping = mock(Hash)
      field_ids_to_ignore = mock(Array)
      converters = mock(Hash)
      fp = @fp.new(:mapping => mapping, :field_ids_to_ignore => field_ids_to_ignore, :converters => converters)
      fp.instance_variable_get("@mapping").should == mapping
      fp.instance_variable_get("@field_ids_to_ignore").should == field_ids_to_ignore
      fp.instance_variable_get("@converters").should == converters
      fp.instance_variable_get("@root_fields").should == %w(id remote_addr timestamp payment_status)
    end

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
