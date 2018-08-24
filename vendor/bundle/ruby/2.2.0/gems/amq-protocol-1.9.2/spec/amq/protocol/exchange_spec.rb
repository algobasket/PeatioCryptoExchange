# encoding: binary

require File.expand_path('../../../spec_helper', __FILE__)


module AMQ
  module Protocol
    class Exchange
      describe Declare do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            exchange = 'amqclient.adapters.em.exchange1'
            type = 'fanout'
            passive = false
            durable = false
            auto_delete = false
            internal = false
            nowait = false
            arguments = nil
            method_frame = Declare.encode(channel, exchange, type, passive, durable, auto_delete, internal, nowait, arguments)
            method_frame.payload.should == "\x00(\x00\n\x00\x00\x1Famqclient.adapters.em.exchange1\x06fanout\x00\x00\x00\x00\x00"
            method_frame.channel.should == 1
          end
        end
      end

      describe Declare, "encoded with a symbol name" do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            exchange = :exchange2
            type = 'fanout'
            passive = false
            durable = false
            auto_delete = false
            internal = false
            nowait = false
            arguments = nil
            method_frame = Declare.encode(channel, exchange, type, passive, durable, auto_delete, internal, nowait, arguments)
            method_frame.payload.should == "\x00(\x00\n\x00\x00\texchange2\x06fanout\x00\x00\x00\x00\x00"
            method_frame.channel.should == 1
          end
        end
      end

      describe Delete do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            exchange = 'amqclient.adapters.em.exchange'
            if_unused = false
            nowait = false
            method_frame = Delete.encode(channel, exchange, if_unused, nowait)
            method_frame.payload.should == "\x00(\x00\x14\x00\x00\x1Eamqclient.adapters.em.exchange\x00"
            method_frame.channel.should == 1
          end
        end
      end

      # describe DeleteOk do
      #   describe '.decode' do
      #   end
      # end

      describe Bind do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            destination = 'foo'
            source = 'bar'
            routing_key = 'xyz'
            nowait = false
            arguments = nil
            method_frame = Bind.encode(channel, destination, source, routing_key, nowait, arguments)
            method_frame.payload.should == "\x00(\x00\x1E\x00\x00\x03foo\x03bar\x03xyz\x00\x00\x00\x00\x00"
            method_frame.channel.should == 1
          end
        end
      end

      # describe BindOk do
      #   describe '.decode' do
      #   end
      # end

      describe Unbind do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            destination = 'foo'
            source = 'bar'
            routing_key = 'xyz'
            nowait = false
            arguments = nil
            method_frame = Unbind.encode(channel, destination, source, routing_key, nowait, arguments)
            method_frame.payload.should == "\x00(\x00(\x00\x00\x03foo\x03bar\x03xyz\x00\x00\x00\x00\x00"
            method_frame.channel.should == 1
          end
        end
      end

      # describe UnbindOk do
      #   describe '.decode' do
      #   end
      # end
    end
  end
end
