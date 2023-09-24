# frozen_string_literal: true

RSpec.describe ProcessKillWorker do
  let(:cache_service) { double('CacheService') }
  let(:message_broker_service) { double('MessageBrokerService') }
  let(:channel) { BunnyMock.new.create_channel }
  let(:use_case) { instance_double(ProccessKillUseCase) }
  let(:message) do
    {
      game_id: 1,
      content: 'Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT',
      last_kill: false
    }.stringify_keys
  end

  subject(:worker) { described_class.new(cache_service, message_broker_service, channel) }

  describe '#perform' do
    context 'when ProccessKillUseCase succeeds' do
      it 'calls ProccessKillUseCase.proccess! with the provided arguments' do
        allow(ProccessKillUseCase).to receive(:new).and_return(use_case)

        expect(use_case).to receive(:proccess!) do |log_line|
          expect(log_line.game_id).to eq(message['game_id'])
          expect(log_line.content).to eq(message['content'])
          expect(log_line.last_kill).to eq(message['last_kill'])
        end

        worker.perform(message)
      end
    end

    context 'when ProccessKillUseCase raises an error' do
      it 'rescues the error and logs it' do
        allow(ProccessKillUseCase).to receive(:new).and_return(use_case)

        error_message = 'An error occurred.'
        allow(use_case).to receive(:proccess!).and_raise(StandardError, error_message)

        expect { worker.perform(message) }.to output(/Error on ProcessKillWorker\n#{error_message}/).to_stdout
      end
    end
  end
end
