#
# We use vcr to record interactions with formstack.
# When re-recording, you will need to alter the cassete to remove sensitive data:
#   * change the api_key to "15AEC14F030D81E41C17298A846BBE09" everywhere in formstack.yml
#   * change the form_id to "2541364" everywhere in formstack.yml
#   * change the view_key to "asdSDFASD" and remove all references to other forms
#   * change the remote_addr to "127.0.0.1"
#   * change the form name to "My Form"
#   Do not commit the true values below or in fixtures/vcr_cassettes
#   otherwise any person could access real formstack data.
#

require 'spec_helper'
require 'formstack_integration/formstack_puller'

describe "FormstackPuller" do
  use_vcr_cassette 'formstack', :record => :new_episodes

  before(:each) do
    @api_key = "15AEC14F030D81E41C17298A846BBE09"
    @form_id = "2541364"
  end

  describe "initialization" do
  
    it "should require an api key" do
      lambda{ FormstackIntegration::FormstackPuller.new }.should raise_error("Please initialise with an api_key")
    end
    
    it "should require a form_id" do
      lambda{ FormstackIntegration::FormstackPuller.new(:api_key => @api_key) }.should raise_error("Please initialise with a form_id")
    end
    
  end

  it "should call the passed in form processor" do
    processor = mock(:processor)
    data = mock(Array)
    puller = FormstackIntegration::FormstackPuller.new(:api_key => @api_key, :form_id => @form_id, :processor => processor)
    puller.should_receive(:data).and_return(data)
    processor.should_receive(:process).with(data)
    puller.process
  end

  describe "form_id_from_form_name" do

    it "should return the form id when passed a name" do
      puller = FormstackIntegration::FormstackPuller.new(:api_key => @api_key, :form_id => @form_id)
      puller.form_id_from_form_name("My Form").should eql(@form_id)
    end

    it "should return nil when name is blank" do
      puller = FormstackIntegration::FormstackPuller.new(:api_key => @api_key, :form_id => @form_id)
      puller.form_id_from_form_name("").should be_nil
    end
    
  end

  describe "data" do

    it "should return a well-formed json data payload" do
      puller = FormstackIntegration::FormstackPuller.new(:api_key => @api_key, :form_id => @form_id)
      data = puller.send(:data)
      data.should be_instance_of(Hashie::Mash)
      data.total.should == 1
      data.pages.should == 1
      data.submissions.should be_instance_of(Array)
      submission = data.submissions[0]
      submission.should be_instance_of(Hashie::Mash)
      submission['14719194'].should == "Org name 1"
    end

  end

  describe "delete" do

    it "should delete entries" do
      puller = FormstackIntegration::FormstackPuller.new(:api_key => @api_key, :form_id => @form_id)
      client = mock(:client)
      client.should_receive(:delete).with(1)
      client.should_receive(:delete).with(2)
      puller.instance_variable_set(:@client, client)
      puller.delete([1,2])
    end
    
    it "should not delete entries if @do_not_delete is set" do
      puller = FormstackIntegration::FormstackPuller.new(:api_key => @api_key, :form_id => @form_id, :do_not_delete => true)
      client = mock(:client)
      client.should_not_receive(:delete).with(1)
      client.should_not_receive(:delete).with(2)
      puller.instance_variable_set(:@client, client)
      puller.delete([1,2])
    end

    it "should not delete entries if no ids are passed" do
      puller = FormstackIntegration::FormstackPuller.new(:api_key => @api_key, :form_id => @form_id)
      client = mock(:client)
      client.should_not_receive(:delete)
      puller.instance_variable_set(:@client, client)
      puller.delete
    end
    
  end

end
