# frozen_string_literal: true

# This class proccess a game report requested by message broker
class ProcessReportWorker
  def initialize(cache_service)
    @cache_service = cache_service
  end

  def perform(message)
    ProccessReportUseCase.new(@cache_service).proccess!
  rescue StandardError => e
    puts 'Error on ProcessReportWorker'
    puts e.message
    puts message
  end
end
