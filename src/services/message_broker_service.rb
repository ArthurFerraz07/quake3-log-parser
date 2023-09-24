# frozen_string_literal: true

class MessageBrokerException < StandardError; end

# This class handle the rabbitmq connection
class MessageBrokerService
  attr_accessor :started

  class << self
    def adapter
      Bunny
    end

    def build_connection(params)
      adapter.new params
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
    raise MessageBrokerException, 'Missing message broker connection' unless @connection

    @connection
  end

  def start_connection
    raise MessageBrokerException, 'Connection already started!' if @started

    connection.start
    @started = true
  end

  def close_connection
    connection.close
  end
end
