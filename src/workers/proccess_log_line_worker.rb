# frozen_string_literal: true

# This class parse the log file
class ProcessLogLineWorker
  class << self
    def perform(message)
      log_line_json = JSON.parse(message)

      log_line = LogLine.new

      log_line.game = "game#{log_line_json['game_number']}"
      log_line.content = log_line_json['content']

      ProccessLogLineUseCase.new(log_line).proccess!
    rescue StandardError => e
      puts 'Error on ParseLineWorker'
      puts e.message
    end
  end
end
