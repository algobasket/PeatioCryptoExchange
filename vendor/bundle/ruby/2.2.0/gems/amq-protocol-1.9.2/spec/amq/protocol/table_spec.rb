# encoding: binary

require File.expand_path('../../../spec_helper', __FILE__)
require 'bigdecimal'
require 'time'


module AMQ
  module Protocol
    describe Table do
      timestamp    = Time.utc(2010, 12, 31, 23, 58, 59)
      bigdecimal_1 = BigDecimal.new("1.0")
      bigdecimal_2 = BigDecimal.new("5E-3")
      bigdecimal_3 = BigDecimal.new("-0.01")


      DATA = if one_point_eight?
        {
          {}                       => "\000\000\000\000",
          {"test" => 1}            => "\000\000\000\n\004testI\000\000\000\001",
          {"float" => 1.87}        => "\000\000\000\017\005floatd?\375\353\205\036\270Q\354",
          {"test" => "string"}     => "\000\000\000\020\004testS\000\000\000\006string",
          {"test" => {}}           => "\000\000\000\n\004testF\000\000\000\000",
          {"test" => bigdecimal_1} => "\000\000\000\v\004testD\000\000\000\000\001",
          {"test" => bigdecimal_2} => "\000\000\000\v\004testD\003\000\000\000\005",
          {"test" => timestamp}    => "\000\000\000\016\004testT\000\000\000\000M\036nC"
        }
      else
        {
          {}                       => "\x00\x00\x00\x00",
          {"test" => 1}            => "\x00\x00\x00\n\x04testI\x00\x00\x00\x01",
          {"float" => 1.92}        => "\x00\x00\x00\x0F\x05floatd?\xFE\xB8Q\xEB\x85\x1E\xB8",
          {"test" => "string"}     => "\x00\x00\x00\x10\x04testS\x00\x00\x00\x06string",
          {"test" => {}}           => "\x00\x00\x00\n\x04testF\x00\x00\x00\x00",
          {"test" => bigdecimal_1} => "\x00\x00\x00\v\x04testD\x00\x00\x00\x00\x01",
          {"test" => bigdecimal_2} => "\x00\x00\x00\v\x04testD\x03\x00\x00\x00\x05",
          {"test" => timestamp}    => "\x00\x00\x00\x0e\x04testT\x00\x00\x00\x00M\x1enC"
        }
      end

      describe ".encode" do
        it "should return \"\x00\x00\x00\x00\" for nil" do
          encoded_value = if one_point_eight?
                            "\000\000\000\000"
                          else
                            "\x00\x00\x00\x00"
                          end

          Table.encode(nil).should eql(encoded_value)
        end

        it "should serialize { :test => true }" do
          Table.encode(:test => true).should eql("\x00\x00\x00\a\x04testt\x01")
        end

        it "should serialize { :test => false }" do
          Table.encode(:test => false).should eql("\x00\x00\x00\a\x04testt\x00")
        end

        it "should serialize { :coordinates => { :latitude  => 59.35 } }" do
          Table.encode(:coordinates => { :latitude  => 59.35 }).should eql("\x00\x00\x00#\vcoordinatesF\x00\x00\x00\x12\blatituded@M\xAC\xCC\xCC\xCC\xCC\xCD")
        end

        it "should serialize { :coordinates => { :longitude => 18.066667 } }" do
          Table.encode(:coordinates => { :longitude => 18.066667 }).should eql("\x00\x00\x00$\vcoordinatesF\x00\x00\x00\x13\tlongituded@2\x11\x11\x16\xA8\xB8\xF1")
        end

        DATA.each do |data, encoded|
          it "should return #{encoded.inspect} for #{data.inspect}" do
            Table.encode(data).should eql(encoded)
          end
        end
      end

      describe ".decode" do
        DATA.each do |data, encoded|
          it "should return #{data.inspect} for #{encoded.inspect}" do
            Table.decode(encoded).should eql(data)
          end

          it "is capable of decoding what it encodes" do
            Table.decode(Table.encode(data)).should == data
          end
        end # DATA.each


        it "is capable of decoding boolean table values" do
          input1   = { "boolval" => true }
          Table.decode(Table.encode(input1)).should == input1


          input2   = { "boolval" => false }
          Table.decode(Table.encode(input2)).should == input2
        end


        it "is capable of decoding nil table values" do
          input   = { "nilval" => nil }
          Table.decode(Table.encode(input)).should == input
        end

        it "is capable of decoding nil table in nested hash/map values" do
          input   = { "hash" => {"nil" => nil} }
          Table.decode(Table.encode(input)).should == input
        end

        it "is capable of decoding string table values" do
          input   = { "stringvalue" => "string" }
          Table.decode(Table.encode(input)).should == input
        end

        it "is capable of decoding string table values with UTF-8 characters" do
          input   = { "строка" => "значение" }
          Table.decode(Table.encode(input)).should == input
        end


        it "is capable of decoding integer table values" do
          input   = { "intvalue" => 10 }
          Table.decode(Table.encode(input)).should == input
        end



        it "is capable of decoding long table values" do
          input   = { "longvalue" => 912598613 }
          Table.decode(Table.encode(input)).should == input
        end



        it "is capable of decoding float table values" do
          input   = { "floatvalue" => 100.0 }
          Table.decode(Table.encode(input)).should == input
        end



        it "is capable of decoding time table values" do
          input   = { "intvalue" => Time.parse("2011-07-14 01:17:46 +0400") }
          Table.decode(Table.encode(input)).should == input
        end



        it "is capable of decoding empty hash table values" do
          input   = { "hashvalue" => Hash.new }
          Table.decode(Table.encode(input)).should == input
        end



        it "is capable of decoding empty array table values" do
          input   = { "arrayvalue" => Array.new }
          Table.decode(Table.encode(input)).should == input
        end


        it "is capable of decoding single string value array table values" do
          input   = { "arrayvalue" => ["amq-protocol"] }
          Table.decode(Table.encode(input)).should == input
        end



        it "is capable of decoding simple nested hash table values" do
          input   = { "hashvalue" => { "a" => "b" } }
          Table.decode(Table.encode(input)).should == input
        end



        it "is capable of decoding nil table values" do
          input   = { "nil" => nil }
          Table.decode(Table.encode(input)).should == input
        end

        it 'is capable of decoding 8bit signed integers' do
          output = TableValueDecoder.decode_byte("\xC0",0).first
          output.should == 192
        end

        it 'is capable of decoding 16bit signed integers' do
          output = TableValueDecoder.decode_short("\x06\x8D", 0).first
          output.should == 1677
        end

        it "is capable of decoding tables" do
          input   = {
            "boolval"      => true,
            "intval"       => 1,
            "strval"       => "Test",
            "timestampval" => Time.parse("2011-07-14 01:17:46 +0400"),
            "floatval"     => 3.14,
            "longval"      => 912598613,
            "hashval"      => { "protocol" => "AMQP091", "true" => true, "false" => false, "nil" => nil }
          }
          Table.decode(Table.encode(input)).should == input
        end



        it "is capable of decoding deeply nested tables" do
          input   = {
            "hashval"    => {
              "protocol" => {
                "name"  => "AMQP",
                "major" => 0,
                "minor" => "9",
                "rev"   => 1.0,
                "spec"  => {
                  "url"  => "http://bit.ly/hw2ELX",
                  "utf8" => "à bientôt"
                }
              },
              "true"     => true,
              "false"    => false,
              "nil"      => nil
            }
          }
          Table.decode(Table.encode(input)).should == input
        end



        it "is capable of decoding array values in tables" do
          input1   = {
            "arrayval1" => [198, 3, 77, 8.0, ["inner", "array", { "oh" => "well", "it" => "should work", "3" => 6 }], "two", { "a" => "value", "is" => nil }],
            "arrayval2" => [198, 3, 77, "two", { "a" => "value", "is" => nil }, 8.0, ["inner", "array", { "oh" => "well", "it" => "should work", "3" => 6 }]]
          }
          Table.decode(Table.encode(input1)).should == input1

          now = Time.now
          input2 = {
                       "coordinates" => {
                         "latitude"  => 59.35,
                         "longitude" => 18.066667
                       },
                       "participants" => 11,
                       "venue"        => "Stockholm",
                       "true_field"   => true,
                       "false_field"  => false,
                       "nil_field"    => nil,
                       "ary_field"    => ["one", 2.0, 3]
                     }

          Table.decode(Table.encode(input2)).should == input2

          input3 = { "timely" => { "now" => now } }
          Table.decode(Table.encode(input3))["timely"]["now"].to_i.should == now.to_i
        end

      end # describe
    end
  end
end
