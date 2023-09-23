# frozen_string_literal: true

class CacheException < StandardError; end

# This class privides an interface to interact redis cache
class CacheService
  @connection = nil

  class << self
    def connection
      raise CacheException, 'Missing cache connection' unless @connection

      @connection
    end

    def build_connection(params)
      @connection = Redis.new params
      @connection
    end

    def set(key, value)
      connection.set(key, value)
    end

    def hset(key, value)
      connection.hset(key, value)
    end

    def get(key)
      connection.get(key)
    end

    def hincrby(key, field, increment)
      connection.hincrby(key, field, increment)
    end
  end
end
