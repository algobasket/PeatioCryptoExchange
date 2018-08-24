Currencies
==========

If you are tracking any kind of assets the currencies gem is for you. It contains every currency in the ISO 4217 standard and allows you to add your own as well. So if you decide to take sparkly buttons as a form of payment you can use currencies to display the shiny button unicode symbol ☼ (disclaimer: ☼ may not look like a shiny button to everyone.) when used with something like the money gem. Speaking of the money gem, currencies gives you an ExchangeBank that the money gem can use to convert from one currency to another. There are plans to have ExchangeRate provider plugin system. Right now the rates are either set manually or pulled from Yahoo Finance.

Installation
------------

Currencies is hosted on GemCutter, so simply run the following:

    gem sources -a http://gemcutter.org
    sudo gem install currencies

Or you can install via bundler Gemfile:

    gem 'currencies'

Or you can install via bundler Gemfile with using only ISO4217::Currency (no Currency class):

    gem 'currencies', :require => 'iso4217'

Basic Usage
-----------

Note that Currency class still exist by default.
(is inherited from ISO4217::Currency to keep backward compatibility).

There are two ways to get a currency object. The first is to simply make it.

    ISO4217::Currency.new('USD', :name => 'Dollars', :symbol => '$', :exchange_rate => 1)
    
Or you can lookup a currency by its ISO 4217 code using the *from_code* method.

    ISO4217::Currency.from_code('USD')
    
Once you have a Currency instance you can get basic information about it.

    currency = ISO4217::Currency.from_code('USD')
    currency.code #=> "USD"
    currency.name #=> "Dollars"
    currency.symbol #=> "$"
    currency.exchange_rate #=> 1.0
    currency.exchange_currency #=> "USD"
    
Adding Currencies
-----------------

Currencies keeps an internal list of currencies for use in the ExchangeBank and to be looked up with the *from_code* method. By default this list contains all the currencies in the ISO 4217 standard. A custom currency can be added using the *add* class method.
    
    shiny_button = ISO4217::Currency.new('SBTTN', :name => 'Buttons', :symbol => '☼', :exchange_rate => 1000)
    ISO4217::Currency.add(shiny_button)
    
To do a massive addition of currencies you can load a yaml file using the *load_file* class method.

    ISO4217::Currency.load_file('custom_currency.yaml')
    
And the yaml file should look like ...

    SBTTN:
      name: Buttons
      symbol: ☼
        
Defaults
--------

You can set the base currency by using the *base_currency* class method. This defaults to 'USD'.

    ISO4217::Currency.base_currency = 'GBP'

The exchange rate is either set manually or if nil looked up on Yahoo Finance and cached. If you want to disable looking up the currency set the *import_exchange_rates* class method to false.

    ISO4217::Currency.import_exchange_rates = false


Money Gem
---------

To use with the money gem you just set the default bank to the currencies bank.

    Money.default_bank = ISO4217::Currency::ExchangeBank.new
    
The Currencies ExchangeBank works the same as the one in the money gem except that if an exchange rate isn't set by default it uses what is set in the currencies gem.

ToDo
----

* Plugin exchange rate things
* Add some to_currency methods
* Add more ways to find a currency
* Make the ExchangeBank accept Currency objects

Sponsored By
------------

This gem is sponsored by [Teliax][]. [Teliax][] makes business class Voice, [Centrex][](Including Hosted: IVRs, Ring Groups, Extensions and Day Night Mode) and Data services accessible to anyone. You don't have to be a fortune 500 to sound big!

Note on Patches/Pull Requests
-----------------------------
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2010 hexorx. See LICENSE for details.


[Teliax]: http://teliax.com
[Centrex]: http://en.wikipedia.org/wiki/Centrex
