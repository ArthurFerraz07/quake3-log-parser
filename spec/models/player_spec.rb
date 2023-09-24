# frozen_string_literal: true

RSpec.describe Player do
  let(:player_name) { 'Player1' }
  let(:player_score) { 100 }

  subject(:player) { described_class.new(player_name, player_score) }

  describe '#name' do
    it 'returns the player name' do
      expect(player.name).to eq(player_name)
    end
  end

  describe '#score' do
    it 'returns the player score' do
      expect(player.score).to eq(player_score)
    end

    context 'when score is not provided' do
      subject(:player_without_score) { described_class.new(player_name) }

      it 'returns the default score of 0' do
        expect(player_without_score.score).to eq(0)
      end
    end
  end
end
