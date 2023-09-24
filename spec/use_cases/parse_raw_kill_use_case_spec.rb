RSpec.describe ParseRawKillUseCase do
  let(:log_line) { double('LogLine', game_id: 1, content: 'Player1 bom killed Player2 também bom by MOD_SHOTGUN') }

  describe '.parse!' do
    it 'parses a raw kill log line into a Kill object' do
      kill = described_class.parse!(log_line)
      expect(kill.game_id).to eq(1)
      expect(kill.killer).to eq('Player1 bom')
      expect(kill.killed).to eq('Player2 também bom')
      expect(kill.mean_of_death).to eq('MOD_SHOTGUN')
    end
  end

  describe '.extract_killer' do
    it 'extracts the killer from a kill info string' do
      kill_info = 'Player1 bom killed Player2 também bom by MOD_SHOTGUN'
      killer = described_class.extract_killer(kill_info)
      expect(killer).to eq('Player1 bom')
    end
  end

  describe '.extract_killed' do
    it 'extracts the killed player from a kill info string' do
      kill_info = 'Player1 bom killed Player2 também bom by MOD_SHOTGUN'
      killed = described_class.extract_killed(kill_info)
      expect(killed).to eq('Player2 também bom')
    end
  end

  describe '.extract_mean_of_death' do
    it 'extracts the mean of death from a kill info string' do
      kill_info = 'Player1 bom killed Player2 também bom by MOD_SHOTGUN'
      mean_of_death = described_class.extract_mean_of_death(kill_info)
      expect(mean_of_death).to eq('MOD_SHOTGUN')
    end
  end
end
