# frozen_string_literal: true

require './app'

queue = ARGV[0]

message_broker_service = MessageBrokerService.new

puts "[*] Waiting for messages on #{queue}. To exit press CTRL+C"

message_broker_service.subscribe(queue) do |_delivery_info, _properties, body|
  ProcessLogLineWorker.perform(body)
end
