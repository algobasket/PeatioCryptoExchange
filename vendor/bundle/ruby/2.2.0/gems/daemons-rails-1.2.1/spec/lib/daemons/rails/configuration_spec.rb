require "spec_helper"
require "daemons/rails/configuration"
require "daemons/rails/monitoring"
require "daemons/rails"

describe Daemons::Rails::Configuration do
  subject { Daemons::Rails.configuration }

  describe "Default configuration" do
    describe "rails env" do
      its(:root) { should == Rails.root }
      its(:daemons_path) { should == Rails.root.join('lib', 'daemons') }
    end

    describe "no rails" do
      before :all do
        Dir.chdir Rails.root
        Object.const_set :Rails_, Rails
        Object.send :remove_const, :Rails
      end
      after :all do
        Object.const_set :Rails, Rails_
        Object.send :remove_const, :Rails_
        Dir.chdir Rails.root.parent.parent
      end
      its(:root) { should == Rails_.root }
      its(:daemons_path) { should == Rails_.root.join('lib', 'daemons') }
    end
  end

  describe "Overridden daemons directory" do
    around :each do |example|
      Daemons::Rails.configure do |c|
        c.daemons_path = Rails.root.join('daemons')
      end
      example.run
      Daemons::Rails.configure do |c|
        c.daemons_path = nil
      end
    end

    its(:daemons_path) { should == Rails.root.join('daemons') }

    it "should override daemons directory" do
      Daemons::Rails::Monitoring.daemons_path.should == Rails.root.join('daemons')
      Daemons::Rails::Monitoring.controllers.map(&:app_name).should == %w(test2.rb)
    end
  end
end
