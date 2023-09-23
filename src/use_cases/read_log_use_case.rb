# frozen_string_literal: true

# This class read the log file and publish the line content on the message broker
class ReadLogUseCase
  def initialize(cache_service, message_broker_service, channel)
    @cache_service = cache_service
    @message_broker_service = message_broker_service
    @channel = channel
  end

  def read!(file_name)
    @cache_service.flushall

    current_game = 0

    lines = FileService.readlines(file_name)

    lines.each do |log|
      # break if current_game == 4

      if log.include?('InitGame')
        current_game += 1
        next
      end

      next unless log.include?('Kill')

      @message_broker_service.publish(@channel, 'log', {
        operation: 'proccess_kill',
        game_id: current_game,
        content: log
      }.to_json)
    end

    @cache_service.set('games_count', current_game)
  end
end
