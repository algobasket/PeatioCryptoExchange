# encoding: utf-8

require "spec_helper"
require "amq/settings"

describe AMQ::Settings do
  describe ".default" do
    it "should provide some default values" do
      AMQ::Settings.default.should_not be_nil
      AMQ::Settings.default[:host].should_not be_nil
    end
  end

  describe ".configure(&block)" do
    it "should merge custom settings with default settings" do
      settings = AMQ::Settings.configure(:host => "tagadab")
      settings[:host].should eql("tagadab")
    end

    it "should merge custom settings from AMQP URL with default settings" do
      settings = AMQ::Settings.configure("amqp://tagadab")
      settings[:host].should eql("tagadab")
    end
  end
end
