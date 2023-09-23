# frozen_string_literal: true

# This class handle the application instance
class Application
  @instance = nil
  private_class_method :new

  attr_accessor :message_broker_connection
  attr_reader :started_at

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

  def run!
    p 'Application is running!'
    p "Started at: #{@started_at}"
  end

  def build_message_broker_connection(params)
    MessageBrokerService.build_connection(params)
  end

  def build_cache_connection(params)
    CacheService.build_connection(params)
  end
end
