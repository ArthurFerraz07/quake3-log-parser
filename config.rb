Bundler.require(:default)

Dotenv.load

Dir['src/daemons/*.rb'].each { |file| require "./#{file}" }
Dir['src/models/*.rb'].each { |file| require "./#{file}" }
Dir['src/services/*.rb'].each { |file| require "./#{file}" }
Dir['src/use_cases/*.rb'].each { |file| require "./#{file}" }
Dir['src/workers/*.rb'].each { |file| require "./#{file}" }
Dir['src/*.rb'].each { |file| require "./#{file}" }

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
