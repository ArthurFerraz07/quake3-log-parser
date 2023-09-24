# Assume you have already set up RSpec and configured it.

RSpec.describe Game do
  let(:game_id) { 1 }
  let(:kills) { { 'player1' => 3, 'player2' => -1 } }
  let(:kills_by_means) { { 'player1' => { 'shotgun' => 2, 'pistol' => 1 }, 'player2' => {} } }
  let(:started_at) { Time.now }

  subject(:game) { described_class.new(game_id, kills, kills_by_means, started_at) }

  describe '#id' do
    it 'returns the game id' do
      expect(game.id).to eq(game_id)
    end
  end

  describe '#kills' do
    it 'returns the kills data' do
      expect(game.kills).to eq(kills)
    end
  end

  describe '#kills_by_means' do
    it 'returns the kills by means data' do
      expect(game.kills_by_means).to eq(kills_by_means)
    end
  end

  describe '#started_at' do
    it 'returns the started_at timestamp' do
      expect(game.started_at).to eq(started_at)
    end
  end

  describe '#players' do
    it 'returns the list of players' do
      expected_players = kills.keys
      expect(game.players).to eq(expected_players)
    end
  end

  describe '#to_h' do
    it 'returns a hash representation of the game' do
      expected_hash = {
        game_id.to_s.to_sym => {
          players: game.players,
          kills: game.kills,
          kills_by_means: game.kills_by_means
        }
      }
      expect(game.to_h).to eq(expected_hash)
    end
  end
end
