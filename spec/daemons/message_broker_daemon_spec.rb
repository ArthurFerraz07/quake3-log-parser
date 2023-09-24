# string_frozen_literal: true

RSpec.describe MessageBrokerDaemon do
  let(:message_broker_service) { double('MessageBrokerService') }
  let(:cache_service) { double('CacheService') }
  let(:channel) { double('Channel') }
  let(:queue_name) { 'test_queue' }
  let(:use_case) { instance_double(MessageBrokerUseCase) }

  subject(:daemon) { described_class.new(message_broker_service, cache_service, channel) }

  describe '#run!' do
    it 'prints a message and subscribes to the queue' do
      expect(message_broker_service).to receive(:subscribe).with(channel, queue_name).and_yield(
        ' delivery_info',
        'properties',
        'message_body'
      )

      allow(MessageBrokerUseCase).to receive(:new).and_return(use_case)
      expect(use_case).to receive(:proccess).with('message_body')

      expect do
        daemon.run!(queue_name)
      end.to output(/\[\*\] Waiting for messages on #{queue_name}. To exit press CTRL\+C/).to_stdout
    end
  end
end
