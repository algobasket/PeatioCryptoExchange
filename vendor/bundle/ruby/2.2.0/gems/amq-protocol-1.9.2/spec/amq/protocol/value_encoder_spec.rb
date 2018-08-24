# -*- coding: utf-8 -*-
require File.expand_path('../../../spec_helper', __FILE__)

require 'time'
require "amq/protocol/table_value_encoder"
require "amq/protocol/float_32bit"

module AMQ
  module Protocol
    describe TableValueEncoder do


      it "calculates size of string field values" do
        described_class.field_value_size("amqp").should == 9
        described_class.encode("amqp").bytesize.should == 9

        described_class.field_value_size("amq-protocol").should == 17
        described_class.encode("amq-protocol").bytesize.should == 17

        described_class.field_value_size("à bientôt").should == 16
        described_class.encode("à bientôt").bytesize.should == 16
      end

      it "calculates size of integer field values" do
        described_class.field_value_size(10).should == 5
        described_class.encode(10).bytesize.should == 5
      end

      it "calculates size of float field values (considering them to be 64-bit)" do
        described_class.field_value_size(10.0).should == 9
        described_class.encode(10.0).bytesize.should == 9

        described_class.field_value_size(120000.0).should == 9
        described_class.encode(120000.0).bytesize.should == 9
      end

      it "calculates size of float field values (boxed as 32-bit)" do
        described_class.encode(AMQ::Protocol::Float32Bit.new(10.0)).bytesize.should == 5
        described_class.encode(AMQ::Protocol::Float32Bit.new(120000.0)).bytesize.should == 5
      end

      it "calculates size of boolean field values" do
        described_class.field_value_size(true).should == 2
        described_class.encode(true).bytesize.should == 2

        described_class.field_value_size(false).should == 2
        described_class.encode(false).bytesize.should == 2
      end

      it "calculates size of void field values" do
        described_class.field_value_size(nil).should == 1
        described_class.encode(nil).bytesize.should == 1
      end

      it "calculates size of time field values" do
        t = Time.parse("2011-07-14 01:17:46 +0400")

        described_class.field_value_size(t).should == 9
        described_class.encode(t).bytesize.should == 9
      end


      it "calculates size of basic table field values" do
        input1   = { "key" => "value" }
        described_class.field_value_size(input1).should == 19
        described_class.encode(input1).bytesize.should == 19


        input2   = { "intval" => 1 }
        described_class.field_value_size(input2).should == 17
        described_class.encode(input2).bytesize.should == 17


        input3   = { "intval" => 1, "key" => "value" }
        described_class.field_value_size(input3).should == 31
        described_class.encode(input3).bytesize.should == 31
      end


      it "calculates size of table field values" do
        input1   = {
          "hashval"    => {
            "protocol" => {
              "name"  => "AMQP",
              "major" => 0,
              "minor" => "9",
              "rev"   => 1.0,
              "spec"  => {
                "url"  => "http://bit.ly/hw2ELX",
                "utf8" => one_point_eight? ? "à bientôt" : "à bientôt".force_encoding(::Encoding::ASCII_8BIT)
              }
            },
            "true"     => true,
            "false"    => false,
            "nil"      => nil
          }
        }

        described_class.field_value_size(input1).should == 162
        # puts(described_class.encode(input1).inspect)
        described_class.encode(input1).bytesize.should == 162



        input2   = {
          "boolval"      => true,
          "intval"       => 1,
          "strval"       => "Test",
          "timestampval" => Time.parse("2011-07-14 01:17:46 +0400"),
          "floatval"     => 3.14,
          "longval"      => 912598613,
          "hashval"      => { "protocol" => "AMQP091", "true" => true, "false" => false, "nil" => nil }
        }

        described_class.field_value_size(input2).should == 150
        described_class.encode(input2).bytesize.should == 150
      end

      it "calculates size of basic array field values" do
        input1 = [1, 2, 3]

        described_class.field_value_size(input1).should == 20
        described_class.encode(input1).bytesize.should == 20


        input2 = ["one", "two", "three"]
        described_class.field_value_size(input2).should == 31
        described_class.encode(input2).bytesize.should == 31


        input3 = ["one", 2, "three"]
        described_class.field_value_size(input3).should == 28
        described_class.encode(input3).bytesize.should == 28


        input4 = ["one", 2, "three", ["four", 5, [6.0]]]
        described_class.field_value_size(input4).should == 61
        described_class.encode(input4).bytesize.should == 61
      end


    end # TableValueEncoder
  end # Protocol
end # AMQ
