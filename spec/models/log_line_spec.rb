# frozen_string_literal: true

RSpec.describe LogLine do
  let(:game_id) { 1 }
  let(:content) { 'Player1 killed Player2 with a shotgun.' }
  let(:last_kill) { false }

  subject(:log_line) { described_class.new(game_id, content, last_kill: last_kill) }

  describe '#game_id' do
    it 'returns the game_id id' do
      expect(log_line.game_id).to eq(game_id)
    end
  end

  describe '#content' do
    it 'returns the log line content' do
      expect(log_line.content).to eq(content)
    end
  end

  describe '#last_kill' do
    context 'when last_kill is true' do
      let(:last_kill) { true }

      it 'returns true' do
        expect(log_line.last_kill).to be(true)
      end
    end

    context 'when last_kill is false' do
      it 'returns false' do
        expect(log_line.last_kill).to be(false)
      end
    end
  end
end
