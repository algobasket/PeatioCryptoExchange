# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ISO4217::Currency do
  before(:all) do
    @usd = ISO4217::Currency.from_code(:USD)
    @gbp = ISO4217::Currency.from_code(:GBP)
  end

  it 'should return code' do
    @usd.code.should == 'USD'
    @gbp.code.should == 'GBP'
    @usd[:code].should == 'USD'
    @gbp[:code].should == 'GBP'
    @usd['code'].should == 'USD'
    @gbp['code'].should == 'GBP'
  end

  it 'should return symbol' do
    @usd.symbol.should == '$'
    @gbp.symbol.should == '£'
    @usd[:symbol].should == '$'
    @gbp[:symbol].should == '£'
    @usd['symbol'].should == '$'
    @gbp['symbol'].should == '£'
  end

  it 'should return name' do
    @usd.name.should == 'Dollars'
    @gbp.name.should == 'Pounds'
    @usd[:name].should == 'Dollars'
    @gbp[:name].should == 'Pounds'
    @usd['name'].should == 'Dollars'
    @gbp['name'].should == 'Pounds'
  end

  describe 'from_code' do
    it 'should return new Currency instance when passed iso4217 currency code' do
      ISO4217::Currency.from_code('USD').should be_a(ISO4217::Currency)
    end

    it 'should return a currency with the same code' do
      ISO4217::Currency.from_code('USD').code.should == 'USD'
      ISO4217::Currency.from_code('GBP').code.should == 'GBP'
    end

    it 'should accept symbol' do
      ISO4217::Currency.from_code(:USD).code.should == 'USD'
      ISO4217::Currency.from_code(:GBP).code.should == 'GBP'
    end

    it 'should work with lower case' do
      ISO4217::Currency.from_code('usd').code.should == 'USD'
      ISO4217::Currency.from_code('gbp').code.should == 'GBP'
    end
  end

  describe 'exchange_rate' do
    it 'should return a float' do
      ISO4217::Currency.from_code('GBP').exchange_rate.should be_a(Float)
    end

    it 'should have an exchange rate of 1.0 for the base currency' do
      ISO4217::Currency.from_code(ISO4217::Currency.base_currency).exchange_rate.should == 1.0
    end
  end

  describe ".major_currencies_selection" do
    let(:usd) { [ "USD", mock ] }
    let(:aud) { [ "AUD", mock ] }
    let(:currencies) { [ usd, aud ] }

    context "with default settings" do
      subject do
        ISO4217::Currency.major_currencies_selection(currencies)
      end

      it { should == usd }
    end

    context "with changed major currency to AUD" do
      subject do
        ISO4217::Currency.major_codes = [ "AUD" ]
        ISO4217::Currency.major_currencies_selection(currencies)
      end

      it { should == aud }
    end
  end

  describe ".best_from_currencies" do
    let(:usd) { mock }
    let(:pln) { mock }
    let(:aud) { mock }

    context "when given currencies is nil" do
      subject { ISO4217::Currency.best_from_currencies(nil) }

      it { should be_nil }
    end

    context "when given currencies is empty array" do
      subject { ISO4217::Currency.best_from_currencies([]) }

      it { should be_nil }
    end

    context "when major currency exist within currencies" do
      let(:valid_currencies) { mock(:nil? => false, :empty? => false) }
      subject do
        ISO4217::Currency.stub!(:major_currencies_selection => [mock, usd])
        ISO4217::Currency.best_from_currencies(valid_currencies)
      end

      it { should == usd }
    end

    context "when major currency does not exist within currencies" do
      let(:valid_currencies) { [ [mock, pln], [mock, aud] ] }
      subject do
        ISO4217::Currency.stub!(:major_currencies_selection => nil)
        ISO4217::Currency.best_from_currencies(valid_currencies)
      end

      it { should == pln }
    end
  end

  describe ".list_from_name" do
    let(:euro_currency) { mock(:name => "Euro") }
    let(:euro) { [ [ "EUR", euro_currency ] ] }
    let(:dollar_currency) { mock(:name => "Dollars") }
    let(:dollars) { [
      [ "USD", dollar_currency ],
      [ "AUD", dollar_currency ]
    ] }
    let(:currencies) { euro + dollars }

    subject do
      ISO4217::Currency.stub!(:currencies => currencies)
      ISO4217::Currency.list_from_name("Dollars")
    end

    it { should == dollars }
  end

  describe ".list_from_symbol" do
    let(:euro_currency) { mock(:symbol => "€") }
    let(:euro) { [ [ "EUR", euro_currency ] ] }
    let(:dollar_currency) { mock(:symbol => "$") }
    let(:dollars) { [
      [ "USD", dollar_currency ],
      [ "AUD", dollar_currency ]
    ] }
    let(:currencies) { euro + dollars }

    subject do
      ISO4217::Currency.stub!(:currencies => currencies)
      ISO4217::Currency.list_from_symbol("$")
    end

    it { should == dollars }
  end

  describe ".best_from_name" do
    let(:name) { mock }
    let(:list_from_name) { mock }
    describe "behavior" do
      before do
        ISO4217::Currency.stub!(
          :best_from_currencies => nil,
          :list_from_name => list_from_name
        )
      end
      after { ISO4217::Currency.best_from_name(name) }

      it "should select best from list of currencies with given name" do
        ISO4217::Currency.should_receive(:best_from_currencies).with(list_from_name)
      end

      it "should select list of currencies with given name" do
        ISO4217::Currency.should_receive(:list_from_name).with(name).and_return(list_from_name)
      end
    end

    describe "returns" do
      let(:best_from_currencies) { mock }
      subject do
        ISO4217::Currency.stub!(
          :best_from_currencies => best_from_currencies,
          :list_from_name => list_from_name
        )
        ISO4217::Currency.best_from_name(name)
      end

      it { should == best_from_currencies }
    end
  end

  describe ".best_from_symbol" do
    let(:symbol) { mock }
    let(:list_from_symbol) { mock }
    describe "behavior" do
      before do
        ISO4217::Currency.stub!(
          :best_from_currencies => nil,
          :list_from_symbol => list_from_symbol
        )
      end
      after { ISO4217::Currency.best_from_symbol(symbol) }

      it "should select best from list of currencies with given symbol" do
        ISO4217::Currency.should_receive(:best_from_currencies).with(list_from_symbol)
      end

      it "should select list of currencies with given symbol" do
        ISO4217::Currency.should_receive(:list_from_symbol).with(symbol).and_return(list_from_symbol)
      end
    end

    describe "returns" do
      let(:best_from_currencies) { mock }
      subject do
        ISO4217::Currency.stub!(
          :best_from_currencies => best_from_currencies,
          :list_from_symbol => list_from_symbol
        )
        ISO4217::Currency.best_from_symbol(symbol)
      end

      it { should == best_from_currencies }
    end
  end

  describe ".best_guess" do
    let(:eur) { mock }
    let(:string) { mock(:nil? => false, :empty? => false) }

    context "when string not given" do
      subject { ISO4217::Currency.best_guess(nil) }

      it { should be_nil }
    end

    context "when given empty string" do
      subject { ISO4217::Currency.best_guess("") }

      it { should be_nil }
    end

    context "when code equal to string exist" do
      subject do
        ISO4217::Currency.stub!(:from_code).with(string).and_return(eur)
        ISO4217::Currency.best_guess(string)
      end

      it { should == eur }
    end

    context "when best symbol equal to string exist" do
      subject do
        ISO4217::Currency.stub!(:from_code).with(string).and_return(nil)
        ISO4217::Currency.stub!(:best_from_symbol).with(string).and_return(eur)
        ISO4217::Currency.best_guess(string)
      end

      it { should == eur }
    end

    context "when best name equal to string exist" do
      subject do
        ISO4217::Currency.stub!(:from_code).with(string).and_return(nil)
        ISO4217::Currency.stub!(:best_from_symbol).with(string).and_return(nil)
        ISO4217::Currency.stub!(:best_from_name).with(string).and_return(eur)
        ISO4217::Currency.best_guess(string)
      end

      it { should == eur }
    end

    context "when string not exist in any form" do
      subject do
        ISO4217::Currency.stub!(:from_code).with(string).and_return(nil)
        ISO4217::Currency.stub!(:best_from_symbol).with(string).and_return(nil)
        ISO4217::Currency.stub!(:best_from_name).with(string).and_return(nil)
        ISO4217::Currency.best_guess(string)
      end

      it { should be_nil }
    end

    describe "behavior" do
      it "should run methods in proper order" do
        ISO4217::Currency.should_receive(:from_code).ordered.with("string").and_return(nil)
        ISO4217::Currency.should_receive(:best_from_symbol).ordered.with("string").and_return(nil)
        ISO4217::Currency.should_receive(:best_from_name).ordered.with("string").and_return(nil)
        ISO4217::Currency.best_guess("string")
      end
    end
  end

  describe ".code_from_best_guess" do
    let(:string) { mock }
    let(:code) { mock }
    let(:best_guess) { mock(:try => code) }

    context "when there is best guess" do
      subject do
        ISO4217::Currency.stub!(:best_guess).with(string).and_return(best_guess)
        ISO4217::Currency.code_from_best_guess(string)
      end

      it { should == code }
    end

    context "when there is no best guess" do
      let(:best_guess) { mock(:try => nil) }

      subject do
        ISO4217::Currency.stub!(:best_guess).with(string).and_return(best_guess)
        ISO4217::Currency.code_from_best_guess(string)
      end

      it { should be_nil }
    end

    describe "behavior" do
      before { ISO4217::Currency.stub!(:best_guess).with(string).and_return(best_guess) }
      after { ISO4217::Currency.code_from_best_guess(string) }

      it "should call .best_guess" do
        ISO4217::Currency.should_receive(:best_guess).with(string).and_return(best_guess)
      end

      it "should call #code on best guessed" do
        best_guess.should_receive(:try).with(:code)
      end
    end
  end

  describe "Currency class" do
    context "when loaded via 'iso4217' existance" do
      subject { defined?(Currency) }

      it { should be_false }
    end

    context "when loaded via 'currencies'" do
      before { require 'currencies' }

      describe "existance" do
        subject { defined?(Currency) }

        it { should be_true }
      end

      describe "superclass" do
        subject { Currency.superclass }

        it { should == ISO4217::Currency }
      end
    end
  end

end
