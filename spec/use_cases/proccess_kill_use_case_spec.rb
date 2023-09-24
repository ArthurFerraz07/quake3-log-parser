# frozen_string_literal: true

RSpec.describe ProccessKillUseCase do
  let(:cache_service) { double('CacheService') }
  let(:message_broker_service) { double('MessageBrokerService') }
  let(:channel) { BunnyMock.new.create_channel }
  subject(:use_case) { described_class.new(cache_service, message_broker_service, channel) }

  describe '#proccess!' do
    context 'when the log line is a valid kill and is not the last kill' do
      let(:log_line) { double('LogLine', content: 'Player1 killed Player2 by MOD_SHOTGUN', last_kill: false) }
      let(:kill) { double('Kill') }

      before do
        allow(ParseRawKillUseCase).to receive(:parse!).with(log_line).and_return(kill)
        allow(RegistryDeathUseCase).to receive(:new).with(cache_service).and_return(double('RegistryDeathUseCase', registry!: nil))
      end

      it 'calls ParseRawKillUseCase.parse! to parse the kill' do
        expect(ParseRawKillUseCase).to receive(:parse!).with(log_line).and_return(kill)
        use_case.proccess!(log_line)
      end

      it 'calls RegistryDeathUseCase.registry! to register the kill' do
        expect(RegistryDeathUseCase).to receive(:new).with(cache_service).and_return(double('RegistryDeathUseCase', registry!: nil))
        use_case.proccess!(log_line)
      end
    end

    context 'when the log line is a valid kill and is the last kill' do
      let(:log_line) { double('LogLine', content: 'Player1 killed Player2 by MOD_SHOTGUN', last_kill: true) }
      let(:kill) { double('Kill') }

      before do
        allow(ParseRawKillUseCase).to receive(:parse!).with(log_line).and_return(kill)
        allow(RegistryDeathUseCase).to receive(:new).with(cache_service).and_return(double('RegistryDeathUseCase', registry!: nil))
        allow(message_broker_service).to receive(:publish).with(channel, 'runner', { operation: 'proccess_report' }.to_json)
      end

      it 'calls ParseRawKillUseCase.parse! to parse the kill' do
        expect(ParseRawKillUseCase).to receive(:parse!).with(log_line).and_return(kill)
        use_case.proccess!(log_line)
      end

      it 'calls RegistryDeathUseCase.registry! to register the kill' do
        expect(RegistryDeathUseCase).to receive(:new).with(cache_service).and_return(double('RegistryDeathUseCase', registry!: nil))
        use_case.proccess!(log_line)
      end

      it 'publishes a message to the message broker' do
        expect(message_broker_service).to receive(:publish).with(channel, 'runner', { operation: 'proccess_report' }.to_json)
        use_case.proccess!(log_line)
      end
    end
  end
end
