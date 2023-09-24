# frozen_string_literal: true

# This class proccess a kill log received from message broker
class ProcessKillWorker
  def initialize(cache_service, message_broker_service, channel)
    @cache_service = cache_service
    @message_broker_service = message_broker_service
    @channel = channel
  end

  def perform(message)
    log_line = LogLine.new(message['game_id'], message['content'], last_kill: message['last_kill'])

    ProccessKillUseCase.new(@cache_service, @message_broker_service, @channel).proccess!(log_line)
  rescue StandardError => e
    puts 'Error on ProcessKillWorker'
    puts e.message
  end
end
