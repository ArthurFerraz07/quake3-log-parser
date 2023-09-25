# frozen_string_literal: true

class ProccessKillException < StandardError; end

# This class proccess a log line
# if the line is a kill, will increase the kill count of the current game
class ProccessKillUseCase
  def initialize(cache_service, message_broker_service, channel)
    @cache_service = cache_service
    @message_broker_service = message_broker_service
    @channel = channel
  end

  def proccess!(log_line)
    return if log_line.content.nil? || log_line.content.empty?

    kill = ParseRawKillUseCase.parse!(log_line)

    RegistryDeathUseCase.new(@cache_service).registry!(kill)

    if log_line.last_kill
      @message_broker_service.publish(@channel, ENV['RUNNER_CLUSTER_NAME'], {
        operation: 'proccess_report'
      }.to_json)
    end
  end
end
