# frozen_string_literal: true

RSpec.describe LoggerService do
  @output = []

  before do
    allow(LoggerService).to receive(:p).and_wrap_original do |_original_method, *args|
      @output = []
      @output << args.first
    end
  end

  it 'should log a message with a timestamp' do
    message = 'Test message'
    timestamp = Time.now
    expected_log = "[#{timestamp}] - #{message}"

    LoggerService.log(message)

    expect(@output.last).to eq(expected_log)
  end
end
