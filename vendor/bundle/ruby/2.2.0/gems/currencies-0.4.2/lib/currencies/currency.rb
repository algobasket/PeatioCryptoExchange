module ISO4217
end

class ISO4217::Currency
  class << self
    attr_accessor :currencies
    attr_accessor :base_currency
    attr_accessor :major_codes
    attr_accessor :import_exchange_rates
  end
  
  attr_reader :code, :symbol, :name, :exchange_currency
  
  def initialize(iso_code,opts={})
    @code = iso_code.to_s.upcase
    @name = opts['name']
    @symbol = opts['symbol']
    @exchange_currency = opts['exchange_currency'] || self.class.base_currency
    @exchange_rate = opts['exchange_rate'].to_f if opts['exchange_rate']
  end
  
  def [](value)
    self.instance_variable_get("@#{value}")
  end
  
  def exchange_rate
    @exchange_rate = nil unless @exchange_currency == self.class.base_currency
    @exchange_rate ||= load_exchange_rate
  end
  
  def load_exchange_rate
    @exchange_currency = self.class.base_currency unless @exchange_currency
    return 1.0 if @code == @exchange_currency
    if self.class.import_exchange_rates
      http = Net::HTTP.new('download.finance.yahoo.com', 80)
      response = http.get("/d/quotes.csv?e=.csv&f=sl1d1t1&s=#{@code}#{@exchange_currency}=X")
      rate = response.body.split(',')[1]
      rate == '0.0' ? nil : rate.to_f
    else
      nil
    end
  end  
    
  def self.load_file(file)
    YAML.load_file(file).each do |code,options|
      self.add(self.new(code,options))
    end
  end

  def self.from_code(code)
    self.currencies[code.to_s.upcase]
  end

  def self.major_currencies_selection(currencies)
    currencies.select { |code, currency| self.major_codes.include?(code) }.first
  end

  def self.best_from_currencies(currencies)
    return if currencies.nil? || currencies.empty?
    self.major_currencies_selection(currencies) ? self.major_currencies_selection(currencies)[1] : currencies.first[1]
  end

  def self.list_from_name(name)
    self.currencies.select { |code, currency| currency.name == name }
  end

  def self.list_from_symbol(symbol)
    self.currencies.select { |code, currency| currency.symbol == symbol }
  end

  def self.best_from_name(name)
    self.best_from_currencies(self.list_from_name(name))
  end

  def self.best_from_symbol(symbol)
    self.best_from_currencies(self.list_from_symbol(symbol))
  end

  def self.best_guess(str)
    return if str.nil? || str.empty?
    self.from_code(str) || self.best_from_symbol(str) || self.best_from_name(str)
  end

  def self.code_from_best_guess(str)
    self.best_guess(str).try(:code)
  end

  def self.add(new_currency)
    self.currencies ||= {}
    self.currencies[new_currency.code] = new_currency
  end
  
  load_file(File.join(File.dirname(__FILE__), '..', 'data', 'iso4217.yaml'))
  self.base_currency = 'USD'
  self.major_codes = [ "USD", "EUR", "GBP" ]
  self.import_exchange_rates = true
end
