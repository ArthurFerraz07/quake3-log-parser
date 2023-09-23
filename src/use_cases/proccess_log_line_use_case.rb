# frozen_string_literal: true

class ProccessLogLineException < StandardError; end

# This class proccess a log line
# if the line is a kill, will increase the kill count of the current game
class ProccessLogLineUseCase
  class << self
    def proccess!(log_line)
      ap log_line.game

      line_info = ParseLineUseCase.new(log_line).parse!

      RegistryDeathUseCase.registry!(line_info.game)

      CacheService.hincrby(log_line.game, 'total_kills', 1)
    end
  end
end
