# encoding: binary

require File.expand_path('../../../spec_helper', __FILE__)


module AMQ
  module Protocol
    class Queue
      describe Declare do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            queue = 'hello.world'
            passive = false
            durable = true
            exclusive = true
            auto_delete = true
            nowait = false
            arguments = nil
            method_frame = Declare.encode(channel, queue, passive, durable, exclusive, auto_delete, nowait, arguments)
            method_frame.payload.should == "\x002\x00\n\x00\x00\vhello.world\x0E\x00\x00\x00\x00"
            method_frame.channel.should == 1
          end
        end
      end

      describe DeclareOk do
        describe '.decode' do
          subject do
            DeclareOk.decode(" amq.gen-KduGSqQrpeUo1otnU0TWSA==\x00\x00\x00\x00\x00\x00\x00\x00")
          end
          
          its(:queue) { should == 'amq.gen-KduGSqQrpeUo1otnU0TWSA==' }
          its(:message_count) { should == 0 }
          its(:consumer_count) { should == 0 }
        end
      end

      describe Bind do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            queue = 'hello.world'
            exchange = 'foo.bar'
            routing_key = 'xyz'
            nowait = false
            arguments = nil
            method_frame = Bind.encode(channel, queue, exchange, routing_key, nowait, arguments)
            method_frame.payload.should == "\x002\x00\x14\x00\x00\vhello.world\afoo.bar\x03xyz\x00\x00\x00\x00\x00"
            method_frame.channel.should == 1
          end
        end
      end

      # describe BindOk do
      #   describe '.decode' do
      #   end
      # end

      describe Purge do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            queue = 'hello.world'
            nowait = false
            method_frame = Purge.encode(channel, queue, nowait)
            method_frame.payload.should == "\x002\x00\x1E\x00\x00\vhello.world\x00"
            method_frame.channel.should == 1
          end
        end
      end

      describe PurgeOk do
        describe '.decode' do
          subject do
            PurgeOk.decode("\x00\x00\x00\x02")
          end
          
          its(:message_count) { should == 2 }
        end
      end

      describe Delete do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            queue = 'hello.world'
            if_unused = false
            if_empty = false
            nowait = false
            method_frame = Delete.encode(channel, queue, if_unused, if_empty, nowait)
            method_frame.payload.should == "\x002\x00(\x00\x00\vhello.world\x00"
            method_frame.channel.should == 1
          end
        end
      end

      describe DeleteOk do
        describe '.decode' do
          subject do
            DeleteOk.decode("\x00\x00\x00\x02")
          end
          
          its(:message_count) { should == 2 }
        end
      end

      describe Unbind do
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            queue = 'hello.world'
            exchange = 'foo.bar'
            routing_key = 'xyz'
            arguments = nil
            method_frame = Unbind.encode(channel, queue, exchange, routing_key, arguments)
            method_frame.payload.should == "\x002\x002\x00\x00\vhello.world\afoo.bar\x03xyz\x00\x00\x00\x00"
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
