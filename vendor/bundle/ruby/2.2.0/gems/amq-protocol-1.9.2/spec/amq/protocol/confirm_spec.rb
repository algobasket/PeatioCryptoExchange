# encoding: binary

require File.expand_path('../../../spec_helper', __FILE__)


module AMQ
  module Protocol
    class Confirm
      describe Select do
        describe '.decode' do
          subject do
            Select.decode("\x01")
          end
          
          its(:nowait) { should be_true }
        end
        
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            nowait = true
            method_frame = Select.encode(channel, nowait)
            method_frame.payload.should == "\x00U\x00\n\x01"
            method_frame.channel.should == 1
          end
        end
      end
      
      describe SelectOk do
        # describe '.decode' do
        # end
        
        describe '.encode' do
          it 'encodes the parameters into a MethodFrame' do
            channel = 1
            method_frame = SelectOk.encode(channel)
            method_frame.payload.should == "\000U\000\v"
            method_frame.channel.should == 1
          end
        end
      end
    end
  end
end
