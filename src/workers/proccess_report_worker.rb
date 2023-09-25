# frozen_string_literal: true

# This class proccess a game report requested by message broker
class ProcessReportWorker
  def initialize(cache_service, message_broker_service, channel)
    @cache_service = cache_service
    @message_broker_service = message_broker_service
    @channel = channel
  end

  def perform
    finish_callback = proc do |report|
      puts '-' * 100
      puts JSON.pretty_generate(report)
      puts '-' * 100
      exit(0)
    end

    ProccessReportUseCase.new(@cache_service, @message_broker_service, @channel).proccess!(finish_callback)
  rescue StandardError => e
    puts 'Error on ProcessReportWorker'
    puts e.message
  end
end
