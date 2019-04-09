## Coin Daemon
To the coin daemon's `{coin}.conf` file, include the `-walletnotify` command:

```
# Notify when receiving coins
walletnotify=/usr/local/sbin/rabbitmqadmin publish routing_key=peatio.deposit.coin payload='{"txid":"%s", "channel_key":"COIN_NAME_SINGULAR"}'
```

## Peatio
Peatio files that need to be updated when a new coin is added:


`peatio/current/config/`
* currencies.yml
* deposit_channels.yml
* markets.yml
* withdraw_channels.yml

peatio/current/app/controllers/
* admin/deposits/{coin}s_controller.rb
* admin/withdraws/{coin}s_controller.rb
* private/assets_controller.rb // add into `def index`
* private/deposits/{coin}s_controller.rb
* private/withdraws/{coin}s_controller.rb

peatio/current/app/models/
* admin/ability.rb // add to `def initialize(user)`
* deposits/{coin}.rb
* withdraws/{coin}.rb

peatio/current/app/views/
* admin/deposits/{coin}s/index.html.slim
* admin/withdraws/{coin}s/_table.html.slim
* admin/withdraws/{coin}s/index.html.slim
* admin/withdraws/{coin}s/show.html.slim
* private/assets/\_{cur\_code}\_assets.html.slim
* app/views/private/assets/\_liability\_tabs.html.slim // add to `.ul.nav.nav-tabs` and `.tab-content`
* app/views/private/assets/index.html.slim // add to `ul.nav.nav-justified.asssets-nav` and `content_for`
* private/deposits/{coin}s/new.html.slim
* private/withdraws/{coin}s/new.html.slim // include `edit.html.slim` in the directory, but no changes needed to that file
* 

peatio/current/config/locales/
* en.yml
* breadcrumbs/en.yml (// add titles for new routes)
* currency/en.yml (// add new currency titles to the existing list of supported currencies)
* deposits/{coin}s/en.yml
* enumerize/en.yml
* private/assets/en.yml
* private/funds/en.yml
* private/shared/en.yml
* withdraws/{coin}s/en.yml


#### Other
If you are changing base currency from CNY to another base fiat currency (e.g. USD): 

* app/controllers/admin/currency_deposits_controller.rb
* config/locales/banks/en.yml

If you are adding a Peercoin-derived currency, you will need to update `peatio/current/app/models/worker/deposit_coin.rb` ([Source](https://github.com/peatio/peatio/issues/189#issuecomment-53767219))
