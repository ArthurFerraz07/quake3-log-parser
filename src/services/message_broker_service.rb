# frozen_string_literal: true

class MessageBrokerException < StandardError; end

# This class handle the rabbitmq connection
class MessageBrokerService
  MISSING_CONNECTION_EXCEPTION = MessageBrokerException.new('Missing message broker connection')

  class << self
    def build_connection(params)
      Bunny.new params
    end

    def create_channel(connection)
      connection.create_channel
    end
  end

  def initialize(connection)
    @connection = connection
  end

  def publish(channel, queue, message)
    channel.default_exchange.publish(message, routing_key: queue)

    true
  end

  def subscribe(channel, queue, &block)
    channel.queue(queue).subscribe(block: true, &block)
  end

  def connection
    raise MISSING_CONNECTION_EXCEPTION unless @connection

    @connection
  end

  def start_connection
    raise MISSING_CONNECTION_EXCEPTION unless @connection

    @connection.start
  end

  def close_connection
    raise MISSING_CONNECTION_EXCEPTION unless @connection

    @connection.close
  end
end
