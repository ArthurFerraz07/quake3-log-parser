# frozen_string_literal: true

RSpec.describe ProcessReportWorker do
  let(:cache_service) { double('CacheService') }
  let(:message_broker_service) { double('MessageBrokerService') }
  let(:channel) { BunnyMock.new.create_channel }
  let(:use_case) { instance_double(ProccessReportUseCase) }

  subject(:worker) { described_class.new(cache_service, message_broker_service, channel) }

  describe '#perform' do
    context 'when ProccessReportUseCase succeeds' do
      it 'calls ProccessReportUseCase.proccess! with the provided arguments' do
        allow(ProccessReportUseCase).to receive(:new).and_return(use_case)

        expect(use_case).to receive(:proccess!)

        worker.perform
      end
    end

    context 'when ProccessReportUseCase raises an error' do
      it 'rescues the error and logs it' do
        allow(ProccessReportUseCase).to receive(:new).and_return(use_case)

        error_message = 'An error occurred.'
        allow(use_case).to receive(:proccess!).and_raise(StandardError, error_message)

        expect { worker.perform }.to output(/Error on ProcessReportWorker\n#{error_message}/).to_stdout
      end
    end
  end
end
