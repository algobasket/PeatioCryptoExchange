# encoding: binary

require File.expand_path('../../../spec_helper', __FILE__)

describe "(Some)", AMQ::Protocol, "constants" do
  it "include regular port" do
    AMQ::Protocol::DEFAULT_PORT.should == 5672
  end

  it "provides TLS/SSL port" do
    AMQ::Protocol::TLS_PORT.should == 5671
    AMQ::Protocol::SSL_PORT.should == 5671
  end
end
