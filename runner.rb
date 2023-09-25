# frozen_string_literal: true

require './config'

default_file = './input/example.txt'

file = ENV['LOG_FILE'] || default_file

app = Application.instance

app.message_broker_service.start_connection

main_channel = MessageBrokerService.create_channel(app.message_broker_service.connection)

LoggerService.log('Starting reading log file...')

ReadLogWorker.new(app.cache_service, app.message_broker_service, main_channel).perform(file)

LoggerService.log('Finished reading log file')

consumer_channel = MessageBrokerService.create_channel(app.message_broker_service.connection)
publisher_channel = MessageBrokerService.create_channel(app.message_broker_service.connection)

queue = ENV['RUNNER_CLUSTER_NAME'] || 'runner'

MessageBrokerDaemon.new(app.message_broker_service, app.cache_service).subscribe!(consumer_channel, publisher_channel, queue)

app.message_broker_service.close_connection
