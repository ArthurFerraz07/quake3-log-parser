# frozen_string_literal: true

# This class read the log file and publish the line content on the message broker
class ReadLogUseCase
  def initialize(file_name)
    @file_name = file_name
  end

  def read!
    load_file_lines

    message_broker_service = MessageBrokerService.new
    current_game = 0

    @file_lines.each do |log|
      current_game += 1 if log.include?('InitGame')

      next unless log.include?('Kill')

      message_broker_service.publish('log', {
        game_number: current_game,
        content: log
      }.to_json)
    end
  end

  private

  def load_file_lines
    @file_lines = FileService.readlines(@file_name)
  end
end
