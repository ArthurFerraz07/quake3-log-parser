# frozen_string_literal: true

require './program'

# default_file = './../inputs/validation.txt'
default_file = './../inputs/example.txt'

file = ARGV[0] || default_file

p "reading #{file} log..."

ReadLogUseCase.new(
  Application.instance.cache_service,
  Application.instance.message_broker_service,
  MessageBrokerService.create_channel(Application.instance.message_broker_service.connection)
).read!(file)
