# frozen_string_literal: true

Bundler.require(:default)

Dotenv.load

Dir['src/models/*.rb'].each { |file| require "./#{file}" }
Dir['src/services/*.rb'].each { |file| require "./#{file}" }
Dir['src/use_cases/*.rb'].each { |file| require "./#{file}" }
Dir['src/workers/*.rb'].each { |file| require "./#{file}" }

require './src/application'

app = Application.instance

message_broker_params = {
  host: ENV['RABBITMQ_HOST'],
  username: ENV['RABBITMQ_USERNAME'],
  password: ENV['RABBITMQ_PASSWORD'],
  port: ENV['RABBITMQ_PORT']
}

cache_params = {
  host: ENV['REDIS_HOST'],
  port: ENV['REDIS_PORT'].to_i
}

app.run!(message_broker_params, cache_params)

app.message_broker_service.start_connection

queue = ARGV[0]

puts "[*] Waiting for messages on #{queue}. To exit press CTRL+C"

app = Application.instance

message_broker_service = app.message_broker_service
cache_service = app.cache_service

channel = MessageBrokerService.create_channel(message_broker_service.connection)

message_broker_service.subscribe(channel, queue) do |_delivery_info, _properties, body|
  # p "[x] Received #{body}"

  MessageBrokerUseCase.new(message_broker_service, cache_service).proccess(body)
end
