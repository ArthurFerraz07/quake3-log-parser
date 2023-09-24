# frozen_string_literal: true

# This class orchestrate the message broker actions
class MessageBrokerUseCase
  def initialize(message_broker_service, cache_service, channel)
    @message_broker_service = message_broker_service
    @cache_service = cache_service
    @channel = channel
  end

  def proccess(body)
    parsed_body = JSON.parse(body)

    case parsed_body['operation']
    when 'proccess_kill'
      ProcessKillWorker.new(@cache_service, @message_broker_service, @channel).perform(parsed_body)
    when 'proccess_report'
      ProcessReportWorker.new(@cache_service).perform(parsed_body)
    when 'read_log'
      ReadLogWorker.new(@cache_service, @message_broker_service, @channel).perform(parsed_body['file'])
    end
  end
end
