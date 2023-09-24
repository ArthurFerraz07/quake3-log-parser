# frozen_string_literal: true

require './config'

default_file = './inputs/validation.txt'
# default_file = './inputs/example.txt'

# file = ARGV[0] || default_file

app = Application.instance

# binding.pry

channel = MessageBrokerService.create_channel(app.message_broker_service.connection)

app.message_broker_service.publish(channel, 'runner', { operation: 'read_log', file: default_file }.to_json)

MessageBrokerDaemon.new(app.message_broker_service, app.cache_service, channel).run!('runner')
