# frozen_string_literal: true

require './app'

queue = ARGV[0]

puts "[*] Waiting for messages on #{queue}. To exit press CTRL+C"
MessageBrokerService.new.subscribe(queue) do |_delivery_info, _properties, body|
  puts "[x] Received #{body}"
end
