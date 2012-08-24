require 'spec_helper'
require 'formstack_integration/converters'

describe "Converters" do

  describe "BooleanConverter" do
  
    before(:each) do
      @klass = FormstackIntegration::Converters::BooleanConverter
    end

    it "should return true when value is 'true'" do
      @klass.new('true').convert.should be_true
    end
    
    it "should return true when value is 'True'" do
      @klass.new('True').convert.should be_true
    end
    
    it "should return false when value is 'false'" do
      @klass.new('false').convert.should be_false
    end
    
    it "should return false when value is empty" do
      @klass.new('').convert.should be_false
    end
    
    it "should return false when value is nil" do
      @klass.new(nil).convert.should be_false
    end
    
  end
  
  describe "ArrayConverter" do
  
    before(:each) do
      @klass = FormstackIntegration::Converters::ArrayConverter
    end
    
    it "should convert a '\\n' separated string to an array" do
      @klass.new("tom\ndick\nharry").convert.should == ['tom', 'dick', 'harry']
    end
    
    it "should convert empty string to empty array" do
      @klass.new("").convert.should == []
    end
    
    it "should convert nil to empty array" do
      @klass.new(nil).convert.should == []
    end

  end
  
  describe "DateConverter" do

    before(:each) do
      @klass = FormstackIntegration::Converters::DateConverter
    end
    
    it "should parse the date from a string" do
      today = Date.today
      @klass.new(today.to_s).convert.should == today
    end
    
    it "should return nil if there is no date to parse" do
      @klass.new(nil).convert.should be_nil
    end
    
  end

end
