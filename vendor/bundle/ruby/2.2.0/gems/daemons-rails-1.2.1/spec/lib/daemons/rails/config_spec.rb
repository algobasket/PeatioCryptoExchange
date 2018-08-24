require 'spec_helper'
require 'daemons/rails/config'

describe Daemons::Rails::Config do
  describe 'daemon controller config' do
    subject { Daemons::Rails::Config.for_controller(Rails.root.join('app', 'daemons', 'test_ctl').to_s) }

    it 'should init options' do
      subject[:script].should == Rails.root.join('app', 'daemons', 'test.rb').to_s
    end
  end
end