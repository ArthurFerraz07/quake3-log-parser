# frozen_string_literal: true

class MessageBrokerException < StandardError; end

# This class handle the rabbitmq connection
class MessageBrokerService
  @connection = nil

  class << self
    def connection
      raise MessageBrokerException, 'Missing message broker connection' unless @connection

      @connection
    end

    def build_connection(params)
      @connection = Bunny.new params
      @connection.start

      @connection
    end
  end

  def initialize
    @channel = self.class.connection.create_channel
  end

  def publish(queue, message)
    @channel.default_exchange.publish(message, routing_key: queue)

    true
  end

  def subscribe(queue, &block)
    @channel.queue(queue).subscribe(block: true, &block)
  end
end
