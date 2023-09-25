# string_frozen_literal: true

RSpec.describe MessageBrokerDaemon do
  let(:message_broker_service) { double('MessageBrokerService') }
  let(:cache_service) { double('CacheService') }
  let(:consumer_channel) { BunnyMock.new.create_channel }
  let(:publisher_channel) { BunnyMock.new.create_channel }
  let(:queue_name) { 'test_queue' }
  let(:use_case) { instance_double(MessageBrokerUseCase) }

  subject(:daemon) { described_class.new(message_broker_service, cache_service) }

  describe '#subscribe!' do
    it 'prints a message and subscribes to the queue' do
      expect(message_broker_service).to receive(:subscribe).with(consumer_channel, queue_name).and_yield(
        ' delivery_info',
        'properties',
        'message_body'
      )

      allow(MessageBrokerUseCase).to receive(:new).and_return(use_case)
      expect(use_case).to receive(:proccess!).with('message_body')

      expect do
        daemon.subscribe!(consumer_channel, publisher_channel, queue_name)
      end.to output(/\[\*\] Waiting for messages on #{queue_name}. To exit press CTRL\+C/).to_stdout
    end
  end
end
