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

  describe 'finish_callback' do
    it 'prints the report' do
      allow($stdout).to receive(:puts)

      allow_any_instance_of(Object).to receive(:exit) do |_, status|
        expect(status).to eq(0)
      end

      report = { name: 'Test User', age: 25, city: 'Test City' }

      callback_proc = worker.send(:finish_callback)
      callback_proc.call(report)

      report_json = JSON.pretty_generate(report)

      expect($stdout).to have_received(:puts).with('----------------------------------------------------------------------------------------------------').twice
      expect($stdout).to have_received(:puts).with(report_json)
    end
  end
end
