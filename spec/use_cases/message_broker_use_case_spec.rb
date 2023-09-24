RSpec.describe MessageBrokerUseCase do
  let(:message_broker_service) { double('MessageBrokerService') }
  let(:cache_service) { double('CacheService') }
  let(:channel) { BunnyMock.new.create_channel }
  let(:json_body) { '{"operation": "proccess_kill", "data": { "game_id": 1, "killer": "Player1", "killed": "Player2", "mean_of_death": "MOD_SHOTGUN" }}' }

  subject(:message_broker_use_case) { described_class.new(message_broker_service, cache_service, channel) }

  describe '#proccess' do
    context 'when operation is "proccess_kill"' do
      it 'delegates to ProcessKillWorker' do
        expect(ProcessKillWorker).to receive(:new).with(cache_service, message_broker_service, channel).and_return(double('ProcessKillWorker', perform: nil))
        message_broker_use_case.proccess(json_body)
      end
    end

    context 'when operation is "proccess_report"' do
      it 'delegates to ProcessReportWorker' do
        expect(ProcessReportWorker).to receive(:new).with(cache_service).and_return(double('ProcessReportWorker', perform: nil))
        message_broker_use_case.proccess(json_body.gsub('proccess_kill', 'proccess_report'))
      end
    end

    context 'when operation is "read_log"' do
      it 'delegates to ReadLogWorker' do
        expect(ReadLogWorker).to receive(:new).with(cache_service, message_broker_service, channel).and_return(double('ReadLogWorker', perform: nil))
        message_broker_use_case.proccess('{"operation": "read_log", "file": "example.log"}')
      end
    end

    context 'when operation is unknown' do
      it 'does not delegate to any worker' do
        expect(ProcessKillWorker).not_to receive(:new)
        expect(ProcessReportWorker).not_to receive(:new)
        expect(ReadLogWorker).not_to receive(:new)
        message_broker_use_case.proccess('{"operation": "unknown_operation"}')
      end
    end
  end
end
