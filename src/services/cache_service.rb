# frozen_string_literal: true

class CacheException < StandardError; end

# This class privides an interface to interact redis cache
class CacheService
  MISSING_CONNECTION_EXCEPTION = CacheException.new('Missing cache connection')

  class << self
    def adapter
      Redis
    end

    def build_connection(params)
      adapter.new params
    end
  end

  def initialize(connection)
    @connection = connection
  end

  def connection
    raise MISSING_CONNECTION_EXCEPTION unless @connection

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

  def flushall
    connection.flushall
  end
end
