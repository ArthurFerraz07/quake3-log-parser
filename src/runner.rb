# frozen_string_literal: true

require './program'

ReadLogUseCase.new(
  Application.instance.cache_service,
  Application.instance.message_broker_service,
  MessageBrokerService.create_channel(Application.instance.message_broker_service.connection)
).read!(ARGV[0] || './../inputs/validation.txt')
