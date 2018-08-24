# encoding: utf-8

require "amq/settings"

require "cgi"
require "uri"

module AMQ
  class URI
    # @private
    AMQP_PORTS = {"amqp" => 5672, "amqps" => 5671}.freeze


    def self.parse(connection_string)
      uri = ::URI.parse(connection_string)
      raise ArgumentError.new("Connection URI must use amqp or amqps schema (example: amqp://bus.megacorp.internal:5766), learn more at http://bit.ly/ks8MXK") unless %w{amqp amqps}.include?(uri.scheme)

      opts = {}

      opts[:scheme] = uri.scheme
      opts[:user]   = ::URI.unescape(uri.user) if uri.user
      opts[:pass]   = ::URI.unescape(uri.password) if uri.password
      opts[:host]   = uri.host if uri.host
      opts[:port]   = uri.port || AMQP_PORTS[uri.scheme]
      opts[:ssl]    = uri.scheme.to_s.downcase =~ /amqps/i
      if uri.path =~ %r{^/(.*)}
        raise ArgumentError.new("#{uri} has multiple-segment path; please percent-encode any slashes in the vhost name (e.g. /production => %2Fproduction). Learn more at http://bit.ly/amqp-gem-and-connection-uris") if $1.index('/')
        opts[:vhost] = ::URI.unescape($1)
      end

      opts
    end
    def self.parse_amqp_url(s)
      parse(s)
    end
  end
end
