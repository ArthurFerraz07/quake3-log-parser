# frozen_string_literal: true

class MessageBrokerDaemon
  def initialize(message_broker_service, cache_service, channel)
    @message_broker_service = message_broker_service
    @cache_service = cache_service
    @channel = channel
  end

  def run!(queue_name)
    puts "[*] Waiting for messages on #{queue_name}. To exit press CTRL+C"

    @message_broker_service.subscribe(@channel, queue_name) do |_delivery_info, _properties, body|
      MessageBrokerUseCase.new(@message_broker_service, @cache_service, @channel).proccess!(body)
    end
  end
end
