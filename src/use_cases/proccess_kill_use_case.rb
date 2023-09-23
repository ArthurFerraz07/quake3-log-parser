# frozen_string_literal: true

class ProccessRawKillException < StandardError; end

# This class proccess a log line
# if the line is a kill, will increase the kill count of the current game
class ProccessRawKillUseCase
  def initialize(cache_service)
    @cache_service = cache_service
  end

  def proccess!(game_id, raw_kill)
    ap game_id
    ap raw_kill

    # line_info = Parse

    # RegistryDeathUseCase.registry!(kill)
  end
end
