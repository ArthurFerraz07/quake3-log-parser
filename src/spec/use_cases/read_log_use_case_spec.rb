# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe ReadLogUseCase do
  let(:cache_service) { instance_double('CacheService') }
  let(:message_broker_service) { instance_double('MessageBrokerService') }
  let(:channel) { BunnyMock.new.create_channel }
  let(:file_name) { 'test.log' }

  subject(:read_log_use_case) { described_class.new(cache_service, message_broker_service, channel) }

  before do
    allow(cache_service).to receive(:flushall)
    allow(FileService).to receive(:readlines).with(file_name).and_return(log_lines)
    allow(message_broker_service).to receive(:publish)
  end

  describe '#read!' do
    context 'when the log file contains relevant data' do
      let(:log_lines) do
        [
          'InitGame: 1',
          'Kill: player1 killed player2',
          'Kill: player3 killed player4',
          'InitGame: 2',
          'Kill: player2 killed player3',
          'Kill: player4 killed playe1',
          'Kill: player5 killed playe6'
        ]
      end

      it 'reads and publishes log entries to the message broker' do
        expect(cache_service).to receive(:flushall)
        expect(FileService).to receive(:readlines).with(file_name).and_return(log_lines)

        expect(message_broker_service).to receive(:publish).with(
          channel,
          'log',
          {
            game_id: 1,
            raw_kill: 'Kill: player1 killed player2'
          }.to_json
        )

        expect(message_broker_service).to receive(:publish).with(
          channel,
          'log',
          {
            game_id: 1,
            raw_kill: 'Kill: player3 killed player4'
          }.to_json
        )

        expect(message_broker_service).to receive(:publish).with(
          channel,
          'log',
          {
            game_id: 2,
            raw_kill: 'Kill: player2 killed player3'
          }.to_json
        )

        expect(message_broker_service).to receive(:publish).with(
          channel,
          'log',
          {
            game_id: 2,
            raw_kill: 'Kill: player4 killed playe1'
          }.to_json
        )

        expect(message_broker_service).to receive(:publish).with(
          channel,
          'log',
          {
            game_id: 2,
            raw_kill: 'Kill: player5 killed playe6'
          }.to_json
        )

        read_log_use_case.read!(file_name)
      end
    end

    context 'when the log file does not contain relevant data' do
      let(:log_lines) do
        [
          'MapStarted: map1',
          'EndGame: 1'
        ]
      end

      it 'does not publish any log entries' do
        expect(cache_service).to receive(:flushall)
        expect(FileService).to receive(:readlines).with(file_name).and_return(log_lines)

        expect(message_broker_service).not_to receive(:publish)

        read_log_use_case.read!(file_name)
      end
    end
  end
end
