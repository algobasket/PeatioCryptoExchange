# Paranoid2

[paranoia gem](https://github.com/radar/paranoia) ideas (and code) adapted for rails 4.

Rails 4 defines `ActiveRecord::Base#destroy!` so `Paranoid2` gem use `force: true` arg to force destroy.

## Installation

Add this line to your application's Gemfile:

    gem 'paranoid2'

And then execute:

    $ bundle

## Usage

Add `deleted_at: datetime` to your model.
Generate and run migrations.

```
rails g migration AddDeletedAtToClients deleted_at:datetime
```
```ruby
class AddDeletedAtToClients < ActiveRecord::Migration
  def change
    add_column :clients, :deleted_at, :datetime
  end
end
```

```ruby

class Client < ActiveRecord::Base
  paranoid
end

c = Client.find(params[:id])

# will set destroyed_at time
c.destroy

# will restore object and all it's associations
c.restore

# will restore only this object without it's associations
c.restore(associations: false)

# will destroy object for real
c.destroy(force: true)

# also useful scopes are available
Client.with_deleted
Client.only_deleted

```

### With paperclip

```ruby
class Listing < ActiveRecord::Base
  has_attached_file :image,
    # ...
    preserve_files: true
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
