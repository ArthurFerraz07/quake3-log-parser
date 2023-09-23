Bundler.require(:default)

Dotenv.load

Dir['models/*.rb'].each { |file| require "./#{file}" }
Dir['services/*.rb'].each { |file| require "./#{file}" }
Dir['use_cases/*.rb'].each { |file| require "./#{file}" }
Dir['workers/*.rb'].each { |file| require "./#{file}" }

require './application'

app = Application.instance

message_broker_params = {
  host: ENV['RABBITMQ_HOST'],
  username: ENV['RABBITMQ_USERNAME'],
  password: ENV['RABBITMQ_PASSWORD'],
  port: ENV['RABBITMQ_PORT']
}

cache_params = {
  host: ENV['REDIS_HOST'],
  port: ENV['REDIS_PORT']
}

app.run!(message_broker_params, cache_params)

app.message_broker_service.start_connection
