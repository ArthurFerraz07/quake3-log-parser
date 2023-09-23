# frozen_string_literal: true

# This class read the log file and publish the line content on the message broker
class ReadLogUseCase
  def initialize(message_broker_service)
    @message_broker_service = message_broker_service
  end

  def read!(file_name)
    CacheService.flushdb

    current_game = 0

    lines = FileService.readlines(file_name)

    lines.each do |log|
      if log.include?('InitGame')
        current_game += 1
        next
      end

      next unless log.include?('Kill')

      message_broker_service.publish('log', {
        game_number: current_game,
        raw_kill: log
      }.to_json)
    end
  end
end
