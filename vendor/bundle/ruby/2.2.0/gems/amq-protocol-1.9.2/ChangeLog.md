## Changes between 1.9.x and 1.10.0

### Signed 16 Bit Integer Decoding

Signed 16 bit integers are now decoded correctly.

Contributed by Benjamin Conlan.



## Changes between 1.8.0 and 1.9.0

### Performance Improvements in AMQ::BitSet

`AMQ::BitSet#next_clear_bit` is now drastically more efficient
(down from 6 minutes for 10,000 iterations to 4 seconds for 65,536 iterations).

Contributed by Doug Rohrer, Dave Anderson, and Jason Voegele from
[Neo](http://www.neo.com).


## Changes between 1.7.0 and 1.8.0

### Body Framing Fix

Messages exactly 128 Kb in size are now framed correctly.

Contributed by Nicolas Viennot.


## Changes between 1.6.0 and 1.7.0

### connection.blocked Support

`connection.blocked` AMQP 0.9.1 extension is now supported
(should be available as of RabbitMQ 3.2).


## Changes between 1.0.0 and 1.1.0

### Performance Enhancements

Encoding of large payloads is now done more efficiently.

Contributed by Greg Brockman.


## Changes between 1.0.0.pre6 and 1.0.0.pre7

### AMQ::Settings

`AMQ::Settings` extracts settings merging logic and AMQP/AMQPS URI parsing from `amq-client`.
Parsing follows the same convention amqp gem and RabbitMQ Java client follow.

Examples:

``` ruby
AMQ::Settings.parse_amqp_url("amqp://dev.rabbitmq.com")            # => vhost is nil, so default (/) will be used
AMQ::Settings.parse_amqp_url("amqp://dev.rabbitmq.com/")           # => vhost is an empty string
AMQ::Settings.parse_amqp_url("amqp://dev.rabbitmq.com/%2Fvault")   # => vhost is /vault
AMQ::Settings.parse_amqp_url("amqp://dev.rabbitmq.com/production") # => vhost is production
AMQ::Settings.parse_amqp_url("amqp://dev.rabbitmq.com/a.b.c")      # => vhost is a.b.c
AMQ::Settings.parse_amqp_url("amqp://dev.rabbitmq.com/foo/bar")    # => ArgumentError
```


### AMQ::Protocol::TLS_PORT

`AMQ::Protocol::TLS_PORT` is a new constant that contains default AMQPS 0.9.1 port,
5671.
