# encoding: utf-8

require 'spec_helper'

require "amq/bit_set"


# extracted from amqp gem. MK.
describe AMQ::BitSet do

  #
  # Environment
  #

  let(:nbits) { (1 << 16) - 1 }


  #
  # Examples
  #

  describe "#new" do
    it "has no bits set at the start" do
      bs = AMQ::BitSet.new(128)
      0.upto(127) do |i|
        bs[i].should == false
      end
    end # it
  end # describe

  describe "#word_index" do
    subject do
      described_class.new(nbits)
    end
    it "returns 0 when the word is between 0 and 63" do
      subject.word_index(0).should == 0
      subject.word_index(63).should == 0
    end # it
    it "returns 1 when the word is between 64 and 127" do
      subject.word_index(64).should == 1
      subject.word_index(127).should == 1
    end # it
    it "returns 2 when the word is between 128 and another number" do
      subject.word_index(128).should == 2
    end # it
  end # describe

  describe "#get, #[]" do
    describe "when bit at given position is set" do
      subject do
        o = described_class.new(nbits)
        o.set(3)
        o
      end

      it "returns true" do
        subject.get(3).should be_true
      end # it
    end # describe

    describe "when bit at given position is off" do
      subject do
        described_class.new(nbits)
      end

      it "returns false" do
        subject.get(5).should be_false
      end # it
    end # describe

    describe "when index out of range" do
      subject do
        described_class.new(nbits)
      end

      it "should raise IndexError for negative index" do
        lambda { subject.get(-1) }.should raise_error(IndexError)
      end # it
      it "should raise IndexError for index >= number of bits" do
        lambda { subject.get(nbits) }.should raise_error(IndexError)
      end # it
    end # describe
  end # describe


  describe "#set" do
    describe "when bit at given position is set" do
      subject do
        described_class.new(nbits)
      end

      it "has no effect" do
        subject.set(3)
        subject.get(3).should be_true
        subject.set(3)
        subject[3].should be_true
      end # it
    end # describe

    describe "when bit at given position is off" do
      subject do
        described_class.new(nbits)
      end

      it "sets that bit" do
        subject.set(3)
        subject.get(3).should be_true

        subject.set(33)
        subject.get(33).should be_true

        subject.set(3387)
        subject.get(3387).should be_true
      end # it
    end # describe

    describe "when index out of range" do
      subject do
        described_class.new(nbits)
      end

      it "should raise IndexError for negative index" do
        lambda { subject.set(-1) }.should raise_error(IndexError)
      end # it
      it "should raise IndexError for index >= number of bits" do
        lambda { subject.set(nbits) }.should raise_error(IndexError)
      end # it
    end # describe
  end # describe


  describe "#unset" do
    describe "when bit at a given position is set" do
      subject do
        described_class.new(nbits)
      end

      it "unsets that bit" do
        subject.set(3)
        subject.get(3).should be_true
        subject.unset(3)
        subject.get(3).should be_false
      end # it
    end # describe


    describe "when bit at a given position is off" do
      subject do
        described_class.new(nbits)
      end

      it "has no effect" do
        subject.get(3).should be_false
        subject.unset(3)
        subject.get(3).should be_false
      end # it
    end # describe

    describe "when index out of range" do
      subject do
        described_class.new(nbits)
      end

      it "should raise IndexError for negative index" do
        lambda { subject.unset(-1) }.should raise_error(IndexError)
      end # it
      it "should raise IndexError for index >= number of bits" do
        lambda { subject.unset(nbits) }.should raise_error(IndexError)
      end # it
    end # describe
  end # describe



  describe "#clear" do
    subject do
      described_class.new(nbits)
    end

    it "clears all bits" do
      subject.set(3)
      subject.get(3).should be_true

      subject.set(7668)
      subject.get(7668).should be_true

      subject.clear

      subject.get(3).should be_false
      subject.get(7668).should be_false
    end # it
  end # describe

  describe "#number_of_trailing_ones" do
    it "calculates them" do
      described_class.number_of_trailing_ones(0).should == 0
      described_class.number_of_trailing_ones(1).should == 1
      described_class.number_of_trailing_ones(2).should == 0
      described_class.number_of_trailing_ones(3).should == 2
      described_class.number_of_trailing_ones(4).should == 0
    end # it
  end # describe

  describe '#next_clear_bit' do
    subject do
      described_class.new(255)
    end
    it "returns sequential values when none have been returned" do
      subject.next_clear_bit.should == 0
      subject.set(0)
      subject.next_clear_bit.should == 1
      subject.set(1)
      subject.next_clear_bit.should == 2
      subject.unset(1)
      subject.next_clear_bit.should == 1
    end # it

    it "returns the same number as long as nothing is set" do
      subject.next_clear_bit.should == 0
      subject.next_clear_bit.should == 0
    end # it

    it "handles more than 128 bits" do
      0.upto(254) do |i|
        subject.set(i)
        subject.next_clear_bit.should == i + 1
      end
      subject.unset(254)
      subject.get(254).should be_false
    end # it
  end # describe
end
