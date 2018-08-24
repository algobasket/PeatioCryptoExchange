# encoding: binary

require File.expand_path('../../spec_helper', __FILE__)


module AMQ
  describe Protocol do
    it "should have PROTOCOL_VERSION constant" do
      Protocol::PROTOCOL_VERSION.should match(/^\d+\.\d+\.\d$/)
    end

    it "should have DEFAULT_PORT constant" do
      Protocol::DEFAULT_PORT.should be_kind_of(Integer)
    end

    it "should have PREAMBLE constant" do
      Protocol::PREAMBLE.should be_kind_of(String)
    end

    describe Protocol::Error do
      it "should be an exception class" do
        Protocol::Error.should < Exception
      end
    end

    describe Protocol::Connection do
      it "should be a subclass of Class" do
        Protocol::Connection.superclass.should == Protocol::Class
      end

      it "should have name equal to connection" do
        Protocol::Connection.name.should eql("connection")
      end

      it "should have method id equal to 10" do
        Protocol::Connection.method_id.should == 10
      end

      describe Protocol::Connection::Start do
        it "should be a subclass of Method" do
          Protocol::Connection::Start.superclass.should == Protocol::Method
        end

        it "should have method name equal to connection.start" do
          Protocol::Connection::Start.name.should eql("connection.start")
        end

        it "should have method id equal to 10" do
          Protocol::Connection::Start.method_id.should == 10
        end
      end

      describe Protocol::Connection::StartOk do
        it "should be a subclass of Method" do
          Protocol::Connection::StartOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to connection.start-ok" do
          Protocol::Connection::StartOk.name.should eql("connection.start-ok")
        end

        it "has method id equal to 11" do
          Protocol::Connection::StartOk.method_id.should == 11
        end
      end

      describe Protocol::Connection::Secure do
        it "should be a subclass of Method" do
          Protocol::Connection::Secure.superclass.should == Protocol::Method
        end

        it "should have method name equal to connection.secure" do
          Protocol::Connection::Secure.name.should eql("connection.secure")
        end

        it "has method id equal to 20" do
          Protocol::Connection::Secure.method_id.should == 20
        end
      end

      describe Protocol::Connection::SecureOk do
        it "should be a subclass of Method" do
          Protocol::Connection::SecureOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to connection.secure-ok" do
          Protocol::Connection::SecureOk.name.should eql("connection.secure-ok")
        end

        it "has method id equal to 21" do
          Protocol::Connection::SecureOk.method_id.should == 21
        end
      end

      describe Protocol::Connection::Tune do
        it "should be a subclass of Method" do
          Protocol::Connection::Tune.superclass.should == Protocol::Method
        end

        it "should have method name equal to connection.tune" do
          Protocol::Connection::Tune.name.should eql("connection.tune")
        end

        it "has method id equal to 30" do
          Protocol::Connection::Tune.method_id.should == 30
        end
      end

      describe Protocol::Connection::TuneOk do
        it "should be a subclass of Method" do
          Protocol::Connection::TuneOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to connection.tune-ok" do
          Protocol::Connection::TuneOk.name.should eql("connection.tune-ok")
        end

        it "has method id equal to 31" do
          Protocol::Connection::TuneOk.method_id.should == 31
        end

        describe ".encode" do
          it do
            frame = Protocol::Connection::TuneOk.encode(0, 131072, 0)
            frame.payload.should eql("\x00\n\x00\x1F\x00\x00\x00\x02\x00\x00\x00\x00")
          end
        end
      end

      describe Protocol::Connection::Open do
        it "should be a subclass of Method" do
          Protocol::Connection::Open.superclass.should == Protocol::Method
        end

        it "should have method name equal to connection.open" do
          Protocol::Connection::Open.name.should eql("connection.open")
        end

        it "has method id equal to 40" do
          Protocol::Connection::Open.method_id.should == 40
        end
      end

      describe Protocol::Connection::OpenOk do
        it "should be a subclass of Method" do
          Protocol::Connection::OpenOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to connection.open-ok" do
          Protocol::Connection::OpenOk.name.should eql("connection.open-ok")
        end

        it "has method id equal to 41" do
          Protocol::Connection::OpenOk.method_id.should == 41
        end
      end

      describe Protocol::Connection::Close do
        it "should be a subclass of Method" do
          Protocol::Connection::Close.superclass.should == Protocol::Method
        end

        it "should have method name equal to connection.close" do
          Protocol::Connection::Close.name.should eql("connection.close")
        end

        it "has method id equal to 50" do
          Protocol::Connection::Close.method_id.should == 50
        end
      end

      describe Protocol::Connection::CloseOk do
        it "should be a subclass of Method" do
          Protocol::Connection::CloseOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to connection.close-ok" do
          Protocol::Connection::CloseOk.name.should eql("connection.close-ok")
        end

        it "has method id equal to 51" do
          Protocol::Connection::CloseOk.method_id.should == 51
        end
      end
    end

    describe Protocol::Channel do
      it "should be a subclass of Class" do
        Protocol::Channel.superclass.should == Protocol::Class
      end

      it "should have name equal to channel" do
        Protocol::Channel.name.should eql("channel")
      end

      it "has method id equal to 20" do
        Protocol::Channel.method_id.should == 20
      end

      describe Protocol::Channel::Open do
        it "should be a subclass of Method" do
          Protocol::Channel::Open.superclass.should == Protocol::Method
        end

        it "should have method name equal to channel.open" do
          Protocol::Channel::Open.name.should eql("channel.open")
        end

        it "has method id equal to 10" do
          Protocol::Channel::Open.method_id.should == 10
        end
      end

      describe Protocol::Channel::OpenOk do
        it "should be a subclass of Method" do
          Protocol::Channel::OpenOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to channel.open-ok" do
          Protocol::Channel::OpenOk.name.should eql("channel.open-ok")
        end

        it "has method id equal to 11" do
          Protocol::Channel::OpenOk.method_id.should == 11
        end
      end

      describe Protocol::Channel::Flow do
        it "should be a subclass of Method" do
          Protocol::Channel::Flow.superclass.should == Protocol::Method
        end

        it "should have method name equal to channel.flow" do
          Protocol::Channel::Flow.name.should eql("channel.flow")
        end

        it "has method id equal to 20" do
          Protocol::Channel::Flow.method_id.should == 20
        end
      end

      describe Protocol::Channel::FlowOk do
        it "should be a subclass of Method" do
          Protocol::Channel::FlowOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to channel.flow-ok" do
          Protocol::Channel::FlowOk.name.should eql("channel.flow-ok")
        end

        it "has method id equal to 21" do
          Protocol::Channel::FlowOk.method_id.should == 21
        end
      end

      describe Protocol::Channel::Close do
        it "should be a subclass of Method" do
          Protocol::Channel::Close.superclass.should == Protocol::Method
        end

        it "should have method name equal to channel.close" do
          Protocol::Channel::Close.name.should eql("channel.close")
        end

        it "has method id equal to 40" do
          Protocol::Channel::Close.method_id.should == 40
        end
      end

      describe Protocol::Channel::CloseOk do
        it "should be a subclass of Method" do
          Protocol::Channel::CloseOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to channel.close-ok" do
          Protocol::Channel::CloseOk.name.should eql("channel.close-ok")
        end

        it "has method id equal to 41" do
          Protocol::Channel::CloseOk.method_id.should == 41
        end
      end
    end

    describe Protocol::Exchange do
      it "should be a subclass of Class" do
        Protocol::Exchange.superclass.should == Protocol::Class
      end

      it "should have name equal to exchange" do
        Protocol::Exchange.name.should eql("exchange")
      end

      it "has method id equal to 40" do
        Protocol::Exchange.method_id.should == 40
      end

      describe Protocol::Exchange::Declare do
        it "should be a subclass of Method" do
          Protocol::Exchange::Declare.superclass.should == Protocol::Method
        end

        it "should have method name equal to exchange.declare" do
          Protocol::Exchange::Declare.name.should eql("exchange.declare")
        end

        it "has method id equal to 10" do
          Protocol::Exchange::Declare.method_id.should == 10
        end
      end

      describe Protocol::Exchange::DeclareOk do
        it "should be a subclass of Method" do
          Protocol::Exchange::DeclareOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to exchange.declare-ok" do
          Protocol::Exchange::DeclareOk.name.should eql("exchange.declare-ok")
        end

        it "has method id equal to 11" do
          Protocol::Exchange::DeclareOk.method_id.should == 11
        end
      end

      describe Protocol::Exchange::Delete do
        it "should be a subclass of Method" do
          Protocol::Exchange::Delete.superclass.should == Protocol::Method
        end

        it "should have method name equal to exchange.delete" do
          Protocol::Exchange::Delete.name.should eql("exchange.delete")
        end

        it "has method id equal to 20" do
          Protocol::Exchange::Delete.method_id.should == 20
        end
      end

      describe Protocol::Exchange::DeleteOk do
        it "should be a subclass of Method" do
          Protocol::Exchange::DeleteOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to exchange.delete-ok" do
          Protocol::Exchange::DeleteOk.name.should eql("exchange.delete-ok")
        end

        it "has method id equal to 21" do
          Protocol::Exchange::DeleteOk.method_id.should == 21
        end
      end

      describe Protocol::Exchange::Bind do
        it "should be a subclass of Method" do
          Protocol::Exchange::Bind.superclass.should == Protocol::Method
        end

        it "should have method name equal to exchange.bind" do
          Protocol::Exchange::Bind.name.should eql("exchange.bind")
        end

        it "has method id equal to 30" do
          Protocol::Exchange::Bind.method_id.should == 30
        end
      end

      describe Protocol::Exchange::BindOk do
        it "should be a subclass of Method" do
          Protocol::Exchange::BindOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to exchange.bind-ok" do
          Protocol::Exchange::BindOk.name.should eql("exchange.bind-ok")
        end

        it "has method id equal to 31" do
          Protocol::Exchange::BindOk.method_id.should == 31
        end
      end

      describe Protocol::Exchange::Unbind do
        it "should be a subclass of Method" do
          Protocol::Exchange::Unbind.superclass.should == Protocol::Method
        end

        it "should have method name equal to exchange.unbind" do
          Protocol::Exchange::Unbind.name.should eql("exchange.unbind")
        end

        it "has method id equal to 40" do
          Protocol::Exchange::Unbind.method_id.should == 40
        end
      end

      describe Protocol::Exchange::UnbindOk do
        it "should be a subclass of Method" do
          Protocol::Exchange::UnbindOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to exchange.unbind-ok" do
          Protocol::Exchange::UnbindOk.name.should eql("exchange.unbind-ok")
        end

        it "has method id equal to 51" do
          Protocol::Exchange::UnbindOk.method_id.should == 51
        end
      end
    end

    describe Protocol::Queue do
      it "should be a subclass of Class" do
        Protocol::Queue.superclass.should == Protocol::Class
      end

      it "should have name equal to queue" do
        Protocol::Queue.name.should eql("queue")
      end

      it "has method id equal to 50" do
        Protocol::Queue.method_id.should == 50
      end

      describe Protocol::Queue::Declare do
        it "should be a subclass of Method" do
          Protocol::Queue::Declare.superclass.should == Protocol::Method
        end

        it "should have method name equal to queue.declare" do
          Protocol::Queue::Declare.name.should eql("queue.declare")
        end

        it "has method id equal to 10" do
          Protocol::Queue::Declare.method_id.should == 10
        end
      end

      describe Protocol::Queue::DeclareOk do
        it "should be a subclass of Method" do
          Protocol::Queue::DeclareOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to queue.declare-ok" do
          Protocol::Queue::DeclareOk.name.should eql("queue.declare-ok")
        end

        it "has method id equal to 11" do
          Protocol::Queue::DeclareOk.method_id.should == 11
        end
      end

      describe Protocol::Queue::Bind do
        it "should be a subclass of Method" do
          Protocol::Queue::Bind.superclass.should == Protocol::Method
        end

        it "should have method name equal to queue.bind" do
          Protocol::Queue::Bind.name.should eql("queue.bind")
        end

        it "has method id equal to 20" do
          Protocol::Queue::Bind.method_id.should == 20
        end
      end

      describe Protocol::Queue::BindOk do
        it "should be a subclass of Method" do
          Protocol::Queue::BindOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to queue.bind-ok" do
          Protocol::Queue::BindOk.name.should eql("queue.bind-ok")
        end

        it "has method id equal to 21" do
          Protocol::Queue::BindOk.method_id.should == 21
        end
      end

      describe Protocol::Queue::Purge do
        it "should be a subclass of Method" do
          Protocol::Queue::Purge.superclass.should == Protocol::Method
        end

        it "should have method name equal to queue.purge" do
          Protocol::Queue::Purge.name.should eql("queue.purge")
        end

        it "has method id equal to 30" do
          Protocol::Queue::Purge.method_id.should == 30
        end
      end

      describe Protocol::Queue::PurgeOk do
        it "should be a subclass of Method" do
          Protocol::Queue::PurgeOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to queue.purge-ok" do
          Protocol::Queue::PurgeOk.name.should eql("queue.purge-ok")
        end

        it "has method id equal to 31" do
          Protocol::Queue::PurgeOk.method_id.should == 31
        end
      end

      describe Protocol::Queue::Delete do
        it "should be a subclass of Method" do
          Protocol::Queue::Delete.superclass.should == Protocol::Method
        end

        it "should have method name equal to queue.delete" do
          Protocol::Queue::Delete.name.should eql("queue.delete")
        end

        it "has method id equal to 40" do
          Protocol::Queue::Delete.method_id.should == 40
        end
      end

      describe Protocol::Queue::DeleteOk do
        it "should be a subclass of Method" do
          Protocol::Queue::DeleteOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to queue.delete-ok" do
          Protocol::Queue::DeleteOk.name.should eql("queue.delete-ok")
        end

        it "has method id equal to 41" do
          Protocol::Queue::DeleteOk.method_id.should == 41
        end
      end

      describe Protocol::Queue::Unbind do
        it "should be a subclass of Method" do
          Protocol::Queue::Unbind.superclass.should == Protocol::Method
        end

        it "should have method name equal to queue.unbind" do
          Protocol::Queue::Unbind.name.should eql("queue.unbind")
        end

        it "has method id equal to 50" do
          Protocol::Queue::Unbind.method_id.should == 50
        end
      end

      describe Protocol::Queue::UnbindOk do
        it "should be a subclass of Method" do
          Protocol::Queue::UnbindOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to queue.unbind-ok" do
          Protocol::Queue::UnbindOk.name.should eql("queue.unbind-ok")
        end

        it "has method id equal to 51" do
          Protocol::Queue::UnbindOk.method_id.should == 51
        end
      end
    end

    describe Protocol::Basic do
      it "should be a subclass of Class" do
        Protocol::Basic.superclass.should == Protocol::Class
      end

      it "should have name equal to basic" do
        Protocol::Basic.name.should eql("basic")
      end

      it "has method id equal to 60" do
        Protocol::Basic.method_id.should == 60
      end

      describe Protocol::Basic::Qos do
        it "should be a subclass of Method" do
          Protocol::Basic::Qos.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.qos" do
          Protocol::Basic::Qos.name.should eql("basic.qos")
        end

        it "has method id equal to 10" do
          Protocol::Basic::Qos.method_id.should == 10
        end
      end

      describe Protocol::Basic::QosOk do
        it "should be a subclass of Method" do
          Protocol::Basic::QosOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.qos-ok" do
          Protocol::Basic::QosOk.name.should eql("basic.qos-ok")
        end

        it "has method id equal to 11" do
          Protocol::Basic::QosOk.method_id.should == 11
        end
      end

      describe Protocol::Basic::Consume do
        it "should be a subclass of Method" do
          Protocol::Basic::Consume.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.consume" do
          Protocol::Basic::Consume.name.should eql("basic.consume")
        end

        it "has method id equal to 20" do
          Protocol::Basic::Consume.method_id.should == 20
        end
      end

      describe Protocol::Basic::ConsumeOk do
        it "should be a subclass of Method" do
          Protocol::Basic::ConsumeOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.consume-ok" do
          Protocol::Basic::ConsumeOk.name.should eql("basic.consume-ok")
        end

        it "has method id equal to 21" do
          Protocol::Basic::ConsumeOk.method_id.should == 21
        end
      end

      describe Protocol::Basic::Cancel do
        it "should be a subclass of Method" do
          Protocol::Basic::Cancel.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.cancel" do
          Protocol::Basic::Cancel.name.should eql("basic.cancel")
        end

        it "has method id equal to 30" do
          Protocol::Basic::Cancel.method_id.should == 30
        end
      end

      describe Protocol::Basic::CancelOk do
        it "should be a subclass of Method" do
          Protocol::Basic::CancelOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.cancel-ok" do
          Protocol::Basic::CancelOk.name.should eql("basic.cancel-ok")
        end

        it "has method id equal to 31" do
          Protocol::Basic::CancelOk.method_id.should == 31
        end
      end

      describe Protocol::Basic::Publish do
        it "should be a subclass of Method" do
          Protocol::Basic::Publish.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.publish" do
          Protocol::Basic::Publish.name.should eql("basic.publish")
        end

        it "has method id equal to 40" do
          Protocol::Basic::Publish.method_id.should == 40
        end
      end

      describe Protocol::Basic::Return do
        it "should be a subclass of Method" do
          Protocol::Basic::Return.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.return" do
          Protocol::Basic::Return.name.should eql("basic.return")
        end

        it "has method id equal to 50" do
          Protocol::Basic::Return.method_id.should == 50
        end
      end

      describe Protocol::Basic::Deliver do
        it "should be a subclass of Method" do
          Protocol::Basic::Deliver.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.deliver" do
          Protocol::Basic::Deliver.name.should eql("basic.deliver")
        end

        it "has method id equal to 60" do
          Protocol::Basic::Deliver.method_id.should == 60
        end
      end

      describe Protocol::Basic::Get do
        it "should be a subclass of Method" do
          Protocol::Basic::Get.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.get" do
          Protocol::Basic::Get.name.should eql("basic.get")
        end

        it "has method id equal to 70" do
          Protocol::Basic::Get.method_id.should == 70
        end
      end

      describe Protocol::Basic::GetOk do
        it "should be a subclass of Method" do
          Protocol::Basic::GetOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.get-ok" do
          Protocol::Basic::GetOk.name.should eql("basic.get-ok")
        end

        it "has method id equal to 71" do
          Protocol::Basic::GetOk.method_id.should == 71
        end
      end

      describe Protocol::Basic::GetEmpty do
        it "should be a subclass of Method" do
          Protocol::Basic::GetEmpty.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.get-empty" do
          Protocol::Basic::GetEmpty.name.should eql("basic.get-empty")
        end

        it "has method id equal to 72" do
          Protocol::Basic::GetEmpty.method_id.should == 72
        end
      end

      describe Protocol::Basic::Ack do
        it "should be a subclass of Method" do
          Protocol::Basic::Ack.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.ack" do
          Protocol::Basic::Ack.name.should eql("basic.ack")
        end

        it "has method id equal to 80" do
          Protocol::Basic::Ack.method_id.should == 80
        end
      end

      describe Protocol::Basic::Reject do
        it "should be a subclass of Method" do
          Protocol::Basic::Reject.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.reject" do
          Protocol::Basic::Reject.name.should eql("basic.reject")
        end

        it "has method id equal to 90" do
          Protocol::Basic::Reject.method_id.should == 90
        end
      end

      describe Protocol::Basic::RecoverAsync do
        it "should be a subclass of Method" do
          Protocol::Basic::RecoverAsync.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.recover-async" do
          Protocol::Basic::RecoverAsync.name.should eql("basic.recover-async")
        end

        it "has method id equal to 100" do
          Protocol::Basic::RecoverAsync.method_id.should == 100
        end
      end

      describe Protocol::Basic::Recover do
        it "should be a subclass of Method" do
          Protocol::Basic::Recover.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.recover" do
          Protocol::Basic::Recover.name.should eql("basic.recover")
        end

        it "has method id equal to 110" do
          Protocol::Basic::Recover.method_id.should == 110
        end
      end

      describe Protocol::Basic::RecoverOk do
        it "should be a subclass of Method" do
          Protocol::Basic::RecoverOk.superclass.should == Protocol::Method
        end

        it "should have method name equal to basic.recover-ok" do
          Protocol::Basic::RecoverOk.name.should eql("basic.recover-ok")
        end

        it "has method id equal to 111" do
          Protocol::Basic::RecoverOk.method_id.should == 111
        end
      end
    end
  end
end