# frozen_string_literal: true

require './config'

queue = ARGV[0]

app = Application.instance

channel = MessageBrokerService.create_channel(app.message_broker_service.connection)

MessageBrokerDaemon.new(app.message_broker_service, app.cache_service, channel).run!(ARGV[0])
