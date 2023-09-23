# frozen_string_literal: true

# This class proccess a log line
# if the line is a kill, will increase the kill count of the current game
class ProccessLogLineUseCase
  def initialize(log_line)
    @log_line = log_line
  end

  def proccess!
    ap @log_line.game

    CacheService.hincrby(@log_line.game, 'total_kills', 1)
  end
end
