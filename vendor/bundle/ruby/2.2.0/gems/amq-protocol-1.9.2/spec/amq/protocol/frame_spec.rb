# encoding: binary

require File.expand_path('../../../spec_helper', __FILE__)


module AMQ
  module Protocol
    describe Frame do
      describe ".encode" do
        it "should raise FrameTypeError if type isn't one of: [:method, :header, :body, :heartbeat]" do
          lambda { Frame.encode(nil, "", 0) }.should raise_error(FrameTypeError)
        end

        it "should raise FrameTypeError if type isn't valid (when type is a symbol)" do
          expect { Frame.encode(:xyz, "test", 12) }.to raise_error(FrameTypeError)
        end

        it "should raise FrameTypeError if type isn't valid (when type is a number)" do
          expect { Frame.encode(16, "test", 12) }.to raise_error(FrameTypeError)
        end

        it "should raise RuntimeError if channel isn't 0 or an integer in range 1..65535" do
          lambda { Frame.encode(:method, "", -1) }.should raise_error(RuntimeError, /^Channel has to be 0 or an integer in range 1\.\.65535/)
          lambda { Frame.encode(:method, "", 65536) }.should raise_error(RuntimeError, /^Channel has to be 0 or an integer in range 1\.\.65535/)
          lambda { Frame.encode(:method, "", 65535) }.should_not raise_error(RuntimeError, /^Channel has to be 0 or an integer in range 1\.\.65535/)
          lambda { Frame.encode(:method, "", 0) }.should_not raise_error(RuntimeError, /^Channel has to be 0 or an integer in range 1\.\.65535/)
          lambda { Frame.encode(:method, "", 1) }.should_not raise_error(RuntimeError, /^Channel has to be 0 or an integer in range 1\.\.65535/)
        end

        it "should raise RuntimeError if payload is nil" do
          lambda { Frame.encode(:method, nil, 0) }.should raise_error(RuntimeError, "Payload can't be nil")
        end

        it "should encode type" do
          Frame.encode(:body, "", 0).unpack("c").first.should eql(3)
        end

        it "should encode channel" do
          Frame.encode(:body, "", 12).unpack("cn").last.should eql(12)
        end

        it "should encode size" do
          Frame.encode(:body, "test", 12).unpack("cnN").last.should eql(4)
        end

        it "should include payload" do
          Frame.encode(:body, "test", 12)[7..-2].should eql("test")
        end

        it "should include final octet" do
          Frame.encode(:body, "test", 12).should =~ /\xCE$/
        end

        it "should encode unicode strings" do
          expect { Frame.encode(:body, "à bientôt!", 12) }.to_not raise_error
        end
      end

      describe ".new" do
        it "should raise FrameTypeError if the type is not one of the accepted" do
          expect { Frame.new(10) }.to raise_error(FrameTypeError)
        end
      end

      describe '#decode_header' do
        it 'raises FrameTypeError if the decoded type is not one of the accepted' do
          expect { Frame.decode_header("\n\x00\x01\x00\x00\x00\x05") }.to raise_error(FrameTypeError)
        end

        it 'raises EmptyResponseError if the header is nil' do
          expect { Frame.decode_header(nil) }.to raise_error(EmptyResponseError)
        end
      end

      describe HeaderFrame do
        subject { HeaderFrame.new("\x00<\x00\x00\x00\x00\x00\x00\x00\x00\x00\n\x98\x00\x18application/octet-stream\x02\x00", nil) }

        it "should decode body_size from payload" do
          subject.body_size.should == 10
        end

        it "should decode klass_id from payload" do
          subject.klass_id.should == 60
        end

        it "should decode weight from payload" do
          subject.weight.should == 0
        end

        it "should decode properties from payload" do
          subject.properties[:delivery_mode].should == 2
          subject.properties[:priority].should == 0
        end
      end
    end
  end
end
