# frozen_string_literal: true

RSpec.describe ReadLogWorker do
  let(:cache_service) { double('CacheService') }
  let(:message_broker_service) { double('MessageBrokerService') }
  let(:channel) { BunnyMock.new.create_channel }
  let(:use_case) { instance_double(ReadLogUseCase) }
  let(:message) { 'example.log' }

  subject(:worker) { described_class.new(cache_service, message_broker_service, channel) }

  describe '#perform' do
    context 'when ReadLogWorker succeeds' do
      it 'calls ReadLogWorker.read! with the provided arguments' do
        allow(ReadLogUseCase).to receive(:new).and_return(use_case)

        expect(use_case).to receive(:read!).with(message)

        worker.perform(message)
      end
    end

    context 'when ReadLogWorker raises an error' do
      it 'rescues the error and logs it' do
        allow(ReadLogUseCase).to receive(:new).and_return(use_case)

        error_message = 'An error occurred.'
        allow(use_case).to receive(:read!).and_raise(StandardError, error_message)

        expect { worker.perform(message) }.to output(/Error on ReadLogWorker\n#{error_message}/).to_stdout
      end
    end
  end
end
