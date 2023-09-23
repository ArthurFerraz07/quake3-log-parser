# frozen_string_literal: true

Bundler.require(:default)

Dotenv.load

Dir['models/*.rb'].each { |file| require "./#{file}" }
Dir['services/*.rb'].each { |file| require "./#{file}" }
Dir['use_cases/*.rb'].each { |file| require "./#{file}" }
Dir['workers/*.rb'].each { |file| require "./#{file}" }

require './application'

app = Application.instance

app.build_message_broker_connection(
  host: ENV['RABBITMQ_HOST'],
  username: ENV['RABBITMQ_USERNAME'],
  password: ENV['RABBITMQ_PASSWORD'],
  port: ENV['RABBITMQ_PORT']
)

app.build_cache_connection(
  host: ENV['REDIS_HOST'],
  port: ENV['REDIS_PORT']
)

app.run!