# frozen_string_literal: true

Bundler.require(:default)

Dir['app/models/*.rb'].each { |file| require "./#{file}" }
Dir['app/services/*.rb'].each { |file| require "./#{file}" }
Dir['app/use_cases/*/*.rb'].each { |file| require "./#{file}" }

require './app/application'

app = Application.instance

app.build_message_broker_connection(
  host: ENV['RABBITMQ_HOST'],
  username: ENV['RABBITMQ_USERNAME'],
  password: ENV['RABBITMQ_PASSWORD'],
  port: ENV['port ']
)

app.run!
