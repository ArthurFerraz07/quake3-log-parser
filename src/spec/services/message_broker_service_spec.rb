# frozen_string_literal: true

require './spec/spec_helper'

describe MessageBrokerService do
  let(:message_broker) { MessageBrokerService.new }
  let(:adapter_mock) { BunnyMock.new }

  before do
    allow(MessageBrokerService).to receive(:build_adapter).and_return(adapter_mock)

    MessageBrokerService.build_connection(
      host: 'test',
      username: 'test',
      password: 'test',
      port: 'test'
    )
  end

  it 'should publish a message' do
    result = message_broker.publish('test_queue', 'Hello, World!')

    expect(BunnyMock).to receive(:default_exchange)
    expect(result).to eq(true)
  end

  # it 'should subscribe to a queue' do
  #   received_message = nil

  #   message_broker.subscribe('test_queue') do |message|
  #     received_message = message
  #   end

  #   expect(received_message).to eq('Received message')
  # end
end
