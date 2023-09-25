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
    @cache_service.set('games_count', current_game)
    @cache_service.set('execution_started_at', Time.now.to_i)

    lines = FileService.readlines(file_name)

    last_kill_index = lines.count - 1 - (lines.reverse.find_index { |log| log.include?('Kill') } || 0)

    lines.each_with_index do |log, i|
      if log.include?('InitGame')
        current_game += 1

        @cache_service.set('games_count', current_game)

        next
      end

      next unless log.include?('Kill')

      @message_broker_service.publish(@channel, ENV['MESSAGE_BROKER_CLUSTER_NAME'], {
        operation: 'proccess_kill',
        game_id: current_game,
        content: log,
        last_kill: last_kill_index == i
      }.to_json)
    end
  end
end
