# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe CacheService do
  let(:adapter_mock) { MockRedis.new }
  let(:cache_service) { CacheService.new(adapter_mock) }
  let(:key) { 'key' }
  let(:value) { 'value' }

  before do
    allow(CacheService).to receive(:adapter).and_return(MockRedis)
  end

  describe '.build_connection' do
    it 'creates a Redis connection' do
      params = { host: 'test', port: 'test' }

      expect(MockRedis).to receive(:new).with(params)

      CacheService.build_connection(params)
    end
  end

  describe '#connection' do
    it 'returns the connection' do
      expect(cache_service.connection).to eq(adapter_mock)
    end

    it 'raises an exception if the connection is missing' do
      service = CacheService.new(nil)
      expect { service.connection }.to raise_error(CacheService::MISSING_CONNECTION_EXCEPTION)
    end
  end

  describe '#set' do
    it 'sets a key-value pair in the cache' do
      expect(adapter_mock).to receive(:set).with(key, value)
      cache_service.set(key, value)
    end
  end

  describe '#get' do
    it 'gets a value from the cache' do
      expect(adapter_mock).to receive(:get).with(key).and_return(value)
      result = cache_service.get(key)
      expect(result).to eq(value)
    end
  end

  describe '#hset' do
    it 'sets a hash field in the cache' do
      hash = {
        'key' => 'value'
      }
      expect(adapter_mock).to receive(:hset).with(key, hash)
      cache_service.hset(key, hash)
    end
  end

  describe '#hincrby' do
    it 'increments a hash field in the cache' do
      field = 'field_name'
      increment = 5
      expect(adapter_mock).to receive(:hincrby).with(key, field, increment)
      cache_service.hincrby(key, field, increment)
    end
  end
end
