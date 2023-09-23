# frozen_string_literal: true

require './program'

queue = ARGV[0]

puts "[*] Waiting for messages on #{queue}. To exit press CTRL+C"

app = Application.instance

message_broker_service = app.message_broker_service
cache_service = app.cache_service

channel = MessageBrokerService.create_channel(message_broker_service.connection)

message_broker_service.subscribe(channel, queue) do |_delivery_info, _properties, body|
  p "[x] Received #{body}"

  MessageBrokerUseCase.new(message_broker_service, cache_service).proccess(body)
end
