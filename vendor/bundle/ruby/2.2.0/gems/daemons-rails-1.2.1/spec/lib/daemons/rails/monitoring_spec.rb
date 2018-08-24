require "spec_helper"
require "daemons/rails/monitoring"
require "ostruct"

describe Daemons::Rails::Monitoring do
  [Daemons::Rails::Monitoring, Daemons::Rails::Monitoring.new(Rails.root.join('lib', 'daemons'))].each do |subject|
    it "should get list of controllers" do
      controllers = subject.controllers
      controllers.should have(1).item
      controller = controllers[0]
      controller.path.should == Rails.root.join('lib', 'daemons', 'test_ctl')
      controller.app_name.should == 'test.rb'
    end

    describe "using controllers" do
      before :each do
        @controller = Daemons::Rails::Controller.new(Rails.root.join('lib', 'daemons', 'test_ctl'))
        Daemons::Rails::Monitoring.any_instance.stub(:controllers).and_return([@controller])
      end

      it "should return status for all controllers" do
        @controller.should_receive(:run).with('status').and_return('test.rb: running [pid 10880]')
        subject.statuses.should == {'test.rb' => :running}
      end

      it "should start controller by name" do
        @controller.should_receive(:run).with('start')
        subject.start('test.rb')
      end

      it "should stop controller by name" do
        @controller.should_receive(:run).with('stop')
        subject.stop('test.rb')
      end
    end
  end

  it "should monitor daemons in other than default directory" do
    Daemons::Rails::Monitoring.new(Rails.root.join('daemons')).controllers.map(&:app_name).should == %w(test2.rb)
  end
end