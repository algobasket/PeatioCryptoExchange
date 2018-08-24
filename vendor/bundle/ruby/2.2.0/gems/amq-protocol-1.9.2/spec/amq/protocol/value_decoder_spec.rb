# -*- coding: utf-8 -*-
require File.expand_path('../../../spec_helper', __FILE__)

require 'time'
require "amq/protocol/table_value_decoder"

module AMQ
  module Protocol
    describe TableValueDecoder do

      it "is capable of decoding basic arrays TableValueEncoder encodes" do
        input1 = [1, 2, 3]

        value, offset = described_class.decode_array(TableValueEncoder.encode(input1), 1)
        value.size.should == 3
        value.first.should == 1
        value.should == input1



        input2 = ["one", 2, "three"]

        value, offset = described_class.decode_array(TableValueEncoder.encode(input2), 1)
        value.size.should == 3
        value.first.should == "one"
        value.should == input2



        input3 = ["one", 2, "three", 4.0, 5000000.0]

        value, offset = described_class.decode_array(TableValueEncoder.encode(input3), 1)
        value.size.should == 5
        value.last.should == 5000000.0
        value.should == input3
      end



      it "is capable of decoding arrays TableValueEncoder encodes" do
        input1 = [{ "one" => 2 }, 3]
        data1  = TableValueEncoder.encode(input1)

        # puts(TableValueEncoder.encode({ "one" => 2 }).inspect)
        # puts(TableValueEncoder.encode(input1).inspect)


        value, offset = described_class.decode_array(data1, 1)
        value.size.should == 2
        value.first.should == Hash["one" => 2]
        value.should == input1



        input2 = ["one", 2, { "three" => { "four" => 5.0 } }]

        value, offset = described_class.decode_array(TableValueEncoder.encode(input2), 1)
        value.size.should == 3
        value.last["three"]["four"].should == 5.0
        value.should == input2
      end

      it "is capable of decoding 32 bit float values" do
        input = Float32Bit.new(10.0)
        data  = TableValueEncoder.encode(input)

        value, offset = described_class.decode_32bit_float(data, 1)
        value.should == 10.0
      end

      context "8bit/byte decoding" do
        let(:examples) {
          {
              0x00 => "\x00",
              0x01 => "\x01",
              0x10 => "\x10",
              255   => "\xFF" # not -1
          }
        }

        it "is capable of decoding byte values" do
          examples.each do |key, value|
            described_class.decode_byte(value, 0).first.should == key
          end
        end
      end
    end
  end
end
