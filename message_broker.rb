# frozen_string_literal: true

require './config'

queue = ARGV[0] || 'message_broker_daemon_cluster'

app = Application.instance

app.message_broker_service.start_connection

channel = MessageBrokerService.create_channel(app.message_broker_service.connection)

MessageBrokerDaemon.new(app.message_broker_service, app.cache_service, channel).run!(queue)

app.message_broker_service.close_connection
