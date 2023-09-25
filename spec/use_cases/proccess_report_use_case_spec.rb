RSpec.describe ProccessReportUseCase do
  let(:cache_service) { double('CacheService') }
  let(:message_broker_service) { double('MessageBrokerService') }
  let(:channel) { BunnyMock.new.create_channel }
  let(:games_count) { 1 }
  let(:game_id) { 1 }
  let(:execution_finished_at) { '100' }
  let(:finish_callback) { proc {} }

  subject(:use_case) { described_class.new(cache_service, message_broker_service, channel) }

  describe '#proccess!' do
    let(:expected_report) do
      {
        players_rank: 'players_rank',
        games: 'games',
        kills_by_means: 'kills_by_means'
      }
    end

    it 'returns a report with players rank, games, and kills by means' do
      allow(Time).to receive(:now).and_return(execution_finished_at)

      expect(cache_service).to receive(:get).with('games_count').and_return(games_count.to_s)
      expect(cache_service).to receive(:set).with('execution_finished_at', execution_finished_at.to_i)
      expect(cache_service).to receive(:set).with('report', expected_report.to_json)

      allow(use_case).to receive(:report_players_rank).and_return('players_rank')
      allow(use_case).to receive(:report_games_base_data).and_return('games')
      allow(use_case).to receive(:report_games_kills_by_means).and_return('kills_by_means')

      report = use_case.proccess!(finish_callback)

      expect(report).to eq(expected_report)
    end
  end

  describe '#report_games_base_data' do
    it 'returns game data for each game' do
      game_data = [
        {
          'game_1' => {
            total_kills: 10,
            kills: { 'Player1' => 5, 'Player2' => 3, 'Player3' => 2 },
            players: %w[Player1 Player2 Player3 Player4]
          }
        }
      ]

      allow(cache_service).to receive(:hgetall).with("games_#{game_id}").and_return('total_kills' => '10')
      allow(cache_service).to receive(:hgetall).with("games_#{game_id}_kills").and_return(
        'Player1' => '5',
        'Player2' => '3',
        'Player3' => '2'
      )
      allow(cache_service).to receive(:hgetall).with("games_#{game_id}_players").and_return(
        'Player1' => '0',
        'Player2' => '0',
        'Player3' => '0',
        'Player4' => '0'
      )

      reported_data = use_case.report_games_base_data(games_count)

      expect(reported_data).to eq(game_data)
    end
  end

  describe '#report_games_kills_by_means' do
    it 'returns kills by means for each game' do
      kills_by_means_data = [
        {
          'game_1' => {
            'MOD_SHOTGUN' => 3,
            'MOD_RAILGUN' => 2
          }
        }
      ]

      allow(cache_service).to receive(:hgetall).with("games_#{game_id}_kills_by_means").and_return(
        'MOD_SHOTGUN' => '3',
        'MOD_RAILGUN' => '2'
      )

      reported_data = use_case.report_games_kills_by_means(games_count)

      expect(reported_data).to eq(kills_by_means_data)
    end
  end

  describe '#report_players_rank' do
    it 'returns player rankings' do
      player_scores = {
        'Player1' => '100',
        'Player2' => '50',
        'Player3' => '75'
      }

      allow(cache_service).to receive(:hgetall).with('players_scores').and_return(player_scores)

      reported_rankings = use_case.report_players_rank

      expect(reported_rankings).to eq([
        { score: 100, player: 'Player1' },
        { score: 75, player: 'Player3' },
        { score: 50, player: 'Player2' }
      ])
    end
  end
end
