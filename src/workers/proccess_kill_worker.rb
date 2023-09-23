# frozen_string_literal: true

# This class proccess a kill log received from message broker
class ProcessKillWorker
  def initialize(cache_service)
    @cache_service = cache_service
  end

  def perform(message)
    log_line_json = JSON.parse(message)

    log_line = LogLine.new(log_line_json['game_id'], log_line_json['content'])

    ProccessRawKillUseCase.new(@cache_service).proccess!(log_line)
  rescue StandardError => e
    puts 'Error on ProcessKillWorker'
    puts e.message
    puts message
  end
end
