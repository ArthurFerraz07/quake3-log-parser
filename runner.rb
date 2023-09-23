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

# default_file = './../inputs/validation.txt'
default_file = './inputs/example.txt'

file = ARGV[0] || default_file

p "reading #{file} log..."

ReadLogUseCase.new(
  Application.instance.cache_service,
  Application.instance.message_broker_service,
  MessageBrokerService.create_channel(Application.instance.message_broker_service.connection)
).read!(file)
