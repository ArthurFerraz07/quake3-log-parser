# frozen_string_literal: true

require './config'

# default_file = './inputs/validation.txt'
default_file = './inputs/example.txt'

file = ARGV[0] || default_file

app = Application.instance

app.message_broker_service.start_connection

channel = MessageBrokerService.create_channel(app.message_broker_service.connection)

app.message_broker_service.publish(channel, 'runner', { operation: 'read_log', file: }.to_json)

binding.pry

app.message_broker_service.close_connection
