require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ISO4217::Currency::ExchangeBank do
  before :each do
    @bank = ISO4217::Currency::ExchangeBank.new
  end
  
  it "returns the previously specified conversion rate" do
    @bank.add_rate("USD", "EUR", 0.788332676)
    @bank.add_rate("EUR", "YEN", 122.631477)
    @bank.get_rate("USD", "EUR").should == 0.788332676
    @bank.get_rate("EUR", "YEN").should == 122.631477
  end
  
  it "treats currency names case-insensitively" do
    @bank.add_rate("usd", "eur", 1)
    @bank.get_rate("USD", "EUR").should == 1
    @bank.same_currency?("USD", "usd").should be_true
    @bank.same_currency?("EUR", "usd").should be_false
  end
  
  it "returns nil if the conversion rate is unknown" do
    @bank.get_rate("American Pesos", "EUR").should be_nil
  end
  
  it "exchanges money from one currency to another according to the specified conversion rates" do
    @bank.add_rate("USD", "EUR", 0.5)
    @bank.add_rate("EUR", "YEN", 10)
    @bank.exchange(10_00, "USD", "EUR").should == 5_00
    @bank.exchange(500_00, "EUR", "YEN").should == 5000_00
  end
  
  it "rounds the exchanged result down" do
    @bank.add_rate("USD", "EUR", 0.788332676)
    @bank.add_rate("EUR", "YEN", 122.631477)
    @bank.exchange(10_00, "USD", "EUR").should == 788
    @bank.exchange(500_00, "EUR", "YEN").should == 6131573
  end
  
  it "should lookup exchange rate if one isn't set" do
    block = lambda { @bank.exchange(10, "USD", "EUR") }
    block.should_not raise_error
  end
  
  it "raises Money::UnknownRate upon conversion if the conversion rate is unknown" do
    block = lambda { @bank.exchange(10, "USD", "BUTTON") }
    block.should raise_error(Money::UnknownRate)
  end
end
