# frozen_string_literal: true

require './config'

default_file = './inputs/validation.txt'
# default_file = './inputs/example.txt'

file = ARGV[0] || default_file

app = Application.instance

app.message_broker_service.start_connection

main_channel = MessageBrokerService.create_channel(app.message_broker_service.connection)

ReadLogWorker.new(app.cache_service, app.message_broker_service, main_channel).perform(file)

consumer_channel = MessageBrokerService.create_channel(app.message_broker_service.connection)

app.message_broker_service.subscribe(consumer_channel, 'runner') do |_delivery_info, _properties, body|
  MessageBrokerUseCase.new(app.message_broker_service, app.cache_service, main_channel).proccess!(body)
end

app.message_broker_service.close_connection
