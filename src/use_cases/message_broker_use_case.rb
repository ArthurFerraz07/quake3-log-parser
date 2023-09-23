# frozen_string_literal: true

# This class orchestrate the message broker actions
class MessageBrokerUseCase
  def initialize(message_broker_service, cache_service)
    @message_broker_service = message_broker_service
    @cache_service = cache_service
  end

  def proccess(body)
    parsed_body = JSON.parse(body)

    case parsed_body['operation']
    when 'proccess_kill'
      ProcessKillWorker.new(@cache_service).perform(body)
    # when 'proccess_report'
      # ProcessReportWorker.new(@cache_service).perform(body)
    end
  end
end
