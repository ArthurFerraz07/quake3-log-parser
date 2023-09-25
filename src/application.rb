# frozen_string_literal: true

class ApplicationException < StandardError; end

# This class handle the application instance
class Application
  @instance = nil
  private_class_method :new

  attr_reader :started_at, :cache_service, :message_broker_service

  class << self
    def instance
      return @instance if @instance

      @instance = new(Time.now)
      @instance
    end
  end

  def initialize(started_at)
    @started_at = started_at
  end

  def run!(message_broker_params, cache_params)
    raise ApplicationException, 'Missing message broker connection params' unless message_broker_params
    raise ApplicationException, 'Missing cache connection params' unless cache_params

    @message_broker_service = MessageBrokerService.new(MessageBrokerService.build_connection(message_broker_params))
    @cache_service = CacheService.new(CacheService.build_connection(cache_params))

    ConstantizeHash.constantize!(Kill, :MEANS_OF_DEATH)

    p 'Application is running!'
    p "Started at: #{@started_at}"
  end
end
