# frozen_string_literal: true

class MessageBrokerException < StandardError; end

# This class handle the rabbitmq connection
class MessageBrokerService
  @message_broker_connection = nil

  class << self
    def connection
      raise MessageBrokerException, 'Missing message broker connection' unless @message_broker_connection

      @message_broker_connection
    end

    def build_connection(params)
      @message_broker_connection = Bunny.new params
      @message_broker_connection.start

      @message_broker_connection
    end
  end

  attr_reader :connection, :channel

  def initialize
    @connection = self.class.connection
    @channel = @connection.create_channel
  end

  def publish(queue, message)
    @channel.default_exchange.publish(message, routing_key: queue)

    true
  end

  def subscribe(queue, &block)
    @channel.queue(queue).subscribe(block: true, &block)
  end
end
