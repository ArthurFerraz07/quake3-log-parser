# frozen_string_literal: true

require './config'

queue = ARGV[0]

puts "[*] Waiting for messages on #{queue}. To exit press CTRL+C"

message_broker_service = Application.instance.message_broker_service
cache_service = Application.instance.cache_service

channel = MessageBrokerService.create_channel(message_broker_service.connection)

Application.instance.message_broker_service.subscribe(channel, queue) do |_delivery_info, _properties, body|
  ProcessKillWorker.new(cache_service).perform(body)
end
