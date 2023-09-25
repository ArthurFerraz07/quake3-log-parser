# frozen_string_literal: true

RSpec.describe Kill do
  let(:game_id) { 1 }
  let(:killer) { 'Player1' }
  let(:killed) { 'Player2' }
  let(:mean_of_death) { Kill::MEANS_OF_DEATH[:MOD_WATER] }

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

  describe 'MEANS_OF_DEATH constant' do
    let(:mean_of_death) do
      {
        MOD_UNKNOWN: 'MOD_UNKNOWN',
        MOD_SHOTGUN: 'MOD_SHOTGUN',
        MOD_GAUNTLET: 'MOD_GAUNTLET',
        MOD_MACHINEGUN: 'MOD_MACHINEGUN',
        MOD_GRENADE: 'MOD_GRENADE',
        MOD_GRENADE_SPLASH: 'MOD_GRENADE_SPLASH',
        MOD_ROCKET: 'MOD_ROCKET',
        MOD_ROCKET_SPLASH: 'MOD_ROCKET_SPLASH',
        MOD_PLASMA: 'MOD_PLASMA',
        MOD_PLASMA_SPLASH: 'MOD_PLASMA_SPLASH',
        MOD_RAILGUN: 'MOD_RAILGUN',
        MOD_LIGHTNING: 'MOD_LIGHTNING',
        MOD_BFG: 'MOD_BFG',
        MOD_BFG_SPLASH: 'MOD_BFG_SPLASH',
        MOD_WATER: 'MOD_WATER',
        MOD_SLIME: 'MOD_SLIME',
        MOD_LAVA: 'MOD_LAVA',
        MOD_CRUSH: 'MOD_CRUSH',
        MOD_TELEFRAG: 'MOD_TELEFRAG',
        MOD_FALLING: 'MOD_FALLING',
        MOD_SUICIDE: 'MOD_SUICIDE',
        MOD_TARGET_LASER: 'MOD_TARGET_LASER',
        MOD_TRIGGER_HURT: 'MOD_TRIGGER_HURT',
        MISSIONPACK: 'MISSIONPACK',
        MOD_NAIL: 'MOD_NAIL',
        MOD_CHAINGUN: 'MOD_CHAINGUN',
        MOD_PROXIMITY_MINE: 'MOD_PROXIMITY_MINE',
        MOD_KAMIKAZE: 'MOD_KAMIKAZE',
        MOD_JUICED: 'MOD_JUICED',
        MOD_GRAPPLE: 'MOD_GRAPPLE'
      }
    end

    it 'defines expected MOD constants' do
      expect(Kill::MEANS_OF_DEATH).to eq(mean_of_death)
    end
  end

  describe '#validate_mean_of_death' do
    let(:mean_of_death) { 'invalid mean' }

    it 'expect return' do
      expect { described_class.new(game_id, killer, killed, mean_of_death) }.to raise_error(KillException, 'invalid mean is not a valid mean of death')
    end
  end
end
