# frozen_string_literal: true

require './config'

queue = ARGV[0] || ENV['MESSAGE_BROKER_CLUSTER_NAME'] || 'message_broker'

app = Application.instance

app.message_broker_service.start_connection

consumer_channel = MessageBrokerService.create_channel(app.message_broker_service.connection)
publisher_channel = MessageBrokerService.create_channel(app.message_broker_service.connection)

MessageBrokerDaemon.new(app.message_broker_service, app.cache_service).subscribe!(consumer_channel, publisher_channel, queue)

app.message_broker_service.close_connection
