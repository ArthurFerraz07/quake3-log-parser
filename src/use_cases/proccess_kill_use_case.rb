# frozen_string_literal: true

class ProccessRawKillException < StandardError; end

# This class proccess a log line
# if the line is a kill, will increase the kill count of the current game
class ProccessRawKillUseCase
  def initialize(cache_service)
    @cache_service = cache_service
  end

  def proccess!(log_line)
    return if log_line.content.nil? || log_line.content.empty?

    kill = ParseRawKillUseCase.parse!(log_line)

    RegistryDeathUseCase.new(@cache_service).registry!(kill)
  end
end
