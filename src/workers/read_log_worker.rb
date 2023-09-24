# frozen_string_literal: true

# This class proccess a read log request received from message broker
class ReadLogWorker
  def initialize(cache_service, message_broker_service, channel)
    @cache_service = cache_service
    @message_broker_service = message_broker_service
    @channel = channel
  end

  def perform(file)
    ReadLogUseCase.new(
      @cache_service,
      @message_broker_service,
      @channel
    ).read!(file)
  rescue StandardError => e
    puts 'Error on ReadLogWorker'
    puts e.message
  end
end
