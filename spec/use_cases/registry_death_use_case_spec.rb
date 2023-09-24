# frozen_string_literal: true

RSpec.describe RegistryDeathUseCase do
  let(:cache_service) { double('CacheService') }
  let(:game_id) { 1 }
  let(:killer) { 'Player1' }
  let(:killed) { 'Player2' }
  let(:mean_of_death) { 'MOD_SHOTGUN' }
  let(:kill) { Kill.new(game_id, killer, killed, mean_of_death) }

  subject(:use_case) { described_class.new(cache_service) }

  describe '#registry!' do
    context 'when a player kills another player' do
      it 'increments the relevant stats' do
        expect(cache_service).to receive(:hincrby).with("games_#{game_id}_kills_by_means", mean_of_death, 1)

        # handle_killer_stats
        expect(cache_service).to receive(:hincrby).with('players_scores', killer, 1)
        expect(cache_service).to receive(:hincrby).with("games_#{game_id}_kills", killer, 1)

        # handle_killed_stats
        # return because world_kill?(kill.killer)

        # handle_game_stats
        expect(cache_service).to receive(:hincrby).with("games_#{game_id}", 'total_kills', 1)

        # registry_player
        expect(cache_service).to receive(:hincrby).with("games_#{game_id}_players", killer, 0)
        expect(cache_service).to receive(:hincrby).with("games_#{game_id}_players", killed, 0)

        use_case.registry!(kill)
      end
    end

    context 'when <world> kills a player' do
      let(:killer) { '<world>' }
      let(:killed) { 'Player2' }

      it 'handle (increment and decrement) the relevant stats' do
        expect(cache_service).to receive(:hincrby).with("games_#{game_id}_kills_by_means", mean_of_death, 1)

        # handle_killer_stats
        # return because world_kill?(kill.killer)

        # handle_killed_stats
        expect(cache_service).to receive(:hincrby).with('players_scores', killed, -1)
        expect(cache_service).to receive(:hincrby).with("games_#{game_id}_kills", killed, -1)

        # handle_game_stats
        expect(cache_service).to receive(:hincrby).with("games_#{game_id}", 'total_kills', 1)

        # registry_player
        expect(cache_service).to receive(:hincrby).with("games_#{game_id}_players", killed, 0)

        use_case.registry!(kill)
      end
    end
  end
end
