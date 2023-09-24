# frozen_string_literal: true

RSpec.describe Kill do
  let(:game_id) { 1 }
  let(:killer) { 'Player1' }
  let(:killed) { 'Player2' }
  let(:mean_of_death) { Kill::MeanOfDeath::MOD_SHOTGUN }

  subject(:kill) { described_class.new(game_id, killer, killed, mean_of_death) }

  describe '#game_id' do
    it 'returns the game id' do
      expect(kill.game_id).to eq(game_id)
    end
  end

  describe '#killer' do
    it 'returns the killer' do
      expect(kill.killer).to eq(killer)
    end
  end

  describe '#killed' do
    it 'returns the killed player' do
      expect(kill.killed).to eq(killed)
    end
  end

  describe '#mean_of_death' do
    it 'returns the mean of death' do
      expect(kill.mean_of_death).to eq(mean_of_death)
    end
  end

  describe 'MeanOfDeath constants' do
    it 'defines expected MOD constants' do
      expect(Kill::MeanOfDeath::MOD_UNKNOWN).to eq('MOD_UNKNOWN')
      expect(Kill::MeanOfDeath::MOD_SHOTGUN).to eq('MOD_SHOTGUN')
      expect(Kill::MeanOfDeath::MOD_GAUNTLET).to eq('MOD_GAUNTLET')
      expect(Kill::MeanOfDeath::MOD_MACHINEGUN).to eq('MOD_MACHINEGUN')
      expect(Kill::MeanOfDeath::MOD_GRENADE).to eq('MOD_GRENADE')
      expect(Kill::MeanOfDeath::MOD_GRENADE_SPLASH).to eq('MOD_GRENADE_SPLASH')
      expect(Kill::MeanOfDeath::MOD_ROCKET).to eq('MOD_ROCKET')
      expect(Kill::MeanOfDeath::MOD_ROCKET_SPLASH).to eq('MOD_ROCKET_SPLASH')
      expect(Kill::MeanOfDeath::MOD_PLASMA).to eq('MOD_PLASMA')
      expect(Kill::MeanOfDeath::MOD_PLASMA_SPLASH).to eq('MOD_PLASMA_SPLASH')
      expect(Kill::MeanOfDeath::MOD_RAILGUN).to eq('MOD_RAILGUN')
      expect(Kill::MeanOfDeath::MOD_LIGHTNING).to eq('MOD_LIGHTNING')
      expect(Kill::MeanOfDeath::MOD_BFG).to eq('MOD_BFG')
      expect(Kill::MeanOfDeath::MOD_BFG_SPLASH).to eq('MOD_BFG_SPLASH')
      expect(Kill::MeanOfDeath::MOD_WATER).to eq('MOD_WATER')
      expect(Kill::MeanOfDeath::MOD_SLIME).to eq('MOD_SLIME')
      expect(Kill::MeanOfDeath::MOD_LAVA).to eq('MOD_LAVA')
      expect(Kill::MeanOfDeath::MOD_CRUSH).to eq('MOD_CRUSH')
      expect(Kill::MeanOfDeath::MOD_TELEFRAG).to eq('MOD_TELEFRAG')
      expect(Kill::MeanOfDeath::MOD_FALLING).to eq('MOD_FALLING')
      expect(Kill::MeanOfDeath::MOD_SUICIDE).to eq('MOD_SUICIDE')
      expect(Kill::MeanOfDeath::MOD_TARGET_LASER).to eq('MOD_TARGET_LASER')
      expect(Kill::MeanOfDeath::MOD_TRIGGER_HURT).to eq('MOD_TRIGGER_HURT')
      expect(Kill::MeanOfDeath::MISSIONPACK).to eq('MISSIONPACK')
      expect(Kill::MeanOfDeath::MOD_NAIL).to eq('MOD_NAIL')
      expect(Kill::MeanOfDeath::MOD_CHAINGUN).to eq('MOD_CHAINGUN')
      expect(Kill::MeanOfDeath::MOD_PROXIMITY_MINE).to eq('MOD_PROXIMITY_MINE')
      expect(Kill::MeanOfDeath::MOD_KAMIKAZE).to eq('MOD_KAMIKAZE')
      expect(Kill::MeanOfDeath::MOD_JUICED).to eq('MOD_JUICED')
      expect(Kill::MeanOfDeath::MOD_GRAPPLE).to eq('MOD_GRAPPLE')
    end
  end
end
