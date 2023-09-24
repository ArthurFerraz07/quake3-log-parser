# frozen_string_literal: true

RSpec.describe MessageBrokerService do
  let(:adapter_mock) { BunnyMock.new }
  let(:message_broker) { MessageBrokerService.new(adapter_mock) }
  let(:channel) { MessageBrokerService.create_channel(adapter_mock) }
  let(:queue_name) { 'test_queue' }
  let(:queue) { channel.queue(queue_name) }
  let(:message) { 'Our goal is to create the best payment network worldwide' }

  describe 'adapter' do
    it 'expects Redis' do
      expect(MessageBrokerService.adapter).to eq(Bunny)
    end
  end

  context 'with mocked bunny' do
    before do
      allow(MessageBrokerService).to receive(:adapter).and_return(BunnyMock)
    end

    describe '.build_connection' do
      it 'creates a Bunny connection' do
        params = {
          host: 'test',
          username: 'test',
          password: 'test',
          port: 'test'
        }

        expect(BunnyMock).to receive(:new).with(params)
        MessageBrokerService.build_connection(params)
      end
    end

    describe '.create_channel' do
      it 'creates a channel on the given connection' do
        expect(adapter_mock).to receive(:create_channel)
        MessageBrokerService.create_channel(adapter_mock)
      end
    end

    describe '#publish' do
      it 'publishes a message to the specified queue' do
        expect(channel.default_exchange).to receive(:publish).with(message, routing_key: queue_name)
        service = MessageBrokerService.new(adapter_mock)
        service.publish(channel, queue_name, message)
      end
    end

    describe '#subscribe' do
      it 'subscribes to the specified queue' do
        expect(channel.queue(queue_name)).to receive(:subscribe).and_yield(double('delivery_info'), double('properties'), message)
        service = MessageBrokerService.new(adapter_mock)
        received_message = nil
        service.subscribe(channel, queue_name) do |_delivery_info, _properties, body|
          received_message = body
        end
        expect(received_message).to eq(message)
      end
    end

    describe '#connection' do
      it 'returns the connection' do
        service = MessageBrokerService.new(adapter_mock)
        expect(service.connection).to eq(adapter_mock)
      end
    end

    describe '#start_connection' do
      it 'starts the connection' do
        expect(adapter_mock).to receive(:start)
        service = MessageBrokerService.new(adapter_mock)
        service.start_connection
      end
    end

    describe '#close_connection' do
      it 'closes the connection' do
        expect(adapter_mock).to receive(:close)
        service = MessageBrokerService.new(adapter_mock)
        service.close_connection
      end
    end
  end
end
