require File.dirname(__FILE__) + '/spec_helper'

describe Behavior do

  include Behavior
  
  before do
    Behavior::Settings.config_file = 'config/behavior.yml'
    BehaviorConfig.make(:key => 'email_address', :value => 'paul@rslw.com')
  end
  
  describe ".config" do
    it "should wonder why" do
      config.should be_a_kind_of(Behavior::Base)
    end
    
    it "should allow accessing the config" do
      config.meta[:email_address][:name].should == "Email Address"
    end

    it "should give me all the keys" do
      config.all.should == ["price", "email_name", "value", "email_address", "description", "password", "options"]
    end
    
    it "should get me my value" do
      config[:email_address].should == "paul@rslw.com"
    end
    
    it "should have a nice default" do
      config[:email_name].should == "Site Administrator"
    end
    
    it "should set the number field to be a number" do
      config[:value].should be_a_kind_of(Fixnum)
    end
  end
  
  describe "#update" do
    it "should let me update the config" do
      config.update(:email_address => 'joe@putplace.com')
      BehaviorConfig.find_by_key('email_address').value.should == "joe@putplace.com"
    end
  end
  
end