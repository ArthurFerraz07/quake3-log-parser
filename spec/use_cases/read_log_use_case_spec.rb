# frozen_string_literal: true

RSpec.describe ReadLogUseCase do
  let(:cache_service) { instance_double('CacheService') }
  let(:message_broker_service) { instance_double('MessageBrokerService') }
  let(:channel) { BunnyMock.new.create_channel }
  let(:file_name) { 'test.message_broker_daemon_cluster' }

  subject(:read_log_use_case) { described_class.new(cache_service, message_broker_service, channel) }

  before do
    allow(cache_service).to receive(:flushall)
    allow(FileService).to receive(:readlines).with(file_name).and_return(log_lines)
    allow(cache_service).to receive(:set)
  end

  describe '#read!' do
    context 'when the message_broker_daemon_cluster file contains relevant data' do
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

      it 'reads and publishes message_broker_daemon_cluster entries to the message broker' do
        expect(cache_service).to receive(:flushall)
        expect(FileService).to receive(:readlines).with(file_name).and_return(log_lines)

        expect(message_broker_service).to receive(:publish).with(
          channel,
          'message_broker_daemon_cluster',
          {
            operation: 'proccess_kill',
            game_id: 1,
            content: 'Kill: player1 killed player2',
            last_kill: false
          }.to_json
        )

        expect(message_broker_service).to receive(:publish).with(
          channel,
          'message_broker_daemon_cluster',
          {
            operation: 'proccess_kill',
            game_id: 1,
            content: 'Kill: player3 killed player4',
            last_kill: false
          }.to_json
        )

        expect(message_broker_service).to receive(:publish).with(
          channel,
          'message_broker_daemon_cluster',
          {
            operation: 'proccess_kill',
            game_id: 2,
            content: 'Kill: player2 killed player3',
            last_kill: false
          }.to_json
        )

        expect(message_broker_service).to receive(:publish).with(
          channel,
          'message_broker_daemon_cluster',
          {
            operation: 'proccess_kill',
            game_id: 2,
            content: 'Kill: player4 killed playe1',
            last_kill: false
          }.to_json
        )

        expect(message_broker_service).to receive(:publish).with(
          channel,
          'message_broker_daemon_cluster',
          {
            operation: 'proccess_kill',
            game_id: 2,
            content: 'Kill: player5 killed playe6',
            last_kill: true
          }.to_json
        )

        expect(cache_service).to receive(:set).with('games_count', 2)

        read_log_use_case.read!(file_name)
      end
    end

    context 'when the message_broker_daemon_cluster file does not contain relevant data' do
      let(:log_lines) do
        [
          'InitGame: 1',
          'MapStarted: map1',
          'EndGame: 1'
        ]
      end

      it 'does not publish any message_broker_daemon_cluster entries' do
        expect(cache_service).to receive(:flushall)
        expect(FileService).to receive(:readlines).with(file_name).and_return(log_lines)
        expect(cache_service).to receive(:set).with('games_count', 1)

        read_log_use_case.read!(file_name)
      end
    end
  end
end
