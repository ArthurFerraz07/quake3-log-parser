# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe Application do
  describe '.instance' do
    it 'returns the same instance for multiple calls' do
      instance1 = described_class.instance
      instance2 = described_class.instance
      expect(instance1).to be(instance2)
    end
  end

  describe '#run!' do
    let(:message_broker_params) { { host: 'localhost', port: 1234 } }
    let(:cache_params) { { host: 'localhost', port: 5678 } }

    it 'creates message broker and cache services' do
      application = described_class.instance

      expect(MessageBrokerService).to receive(:build_connection).with(message_broker_params)
      expect(CacheService).to receive(:build_connection).with(cache_params)

      expect(ConstantizeHash).to receive(:constantize!).with(Kill, :MEANS_OF_DEATH)

      application.run!(message_broker_params, cache_params)
      expect(application.message_broker_service).to be_a(MessageBrokerService)
      expect(application.cache_service).to be_a(CacheService)
    end

    it 'raises an exception when message broker params are missing' do
      application = described_class.instance

      expect { application.run!(nil, cache_params) }.to raise_error(ApplicationException, 'Missing message broker connection params')
    end

    it 'raises an exception when cache params are missing' do
      application = described_class.instance

      expect { application.run!(message_broker_params, nil) }.to raise_error(ApplicationException, 'Missing cache connection params')
    end
  end
end
