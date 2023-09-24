# frozen_string_literal: true

# This class proccess a game report

# "game_1": {
#   "total_kills": 45,
#   "players": ["Dono da bola", "Isgalamido", "Zeh"],
#   "kills": {
#     "Dono da bola": 5,
#     "Isgalamido": 18,
#     "Zeh": 20
#     }
#   }

# game-1": {
#   "kills_by_means": {
#     "MOD_SHOTGUN": 10,
#     "MOD_RAILGUN": 2,
#     "MOD_GAUNTLET": 1,
#     ...
#   }
# }

# "players_rank": [
#   {
#     "player": "Isgalamido",
#     "score": 45,
#   }
# ]

# This class proccess the data collected on input log file and report it
class ProccessReportUseCase
  def initialize(cache_service)
    @cache_service = cache_service
  end

  def proccess!
    games_count = @cache_service.get('games_count').to_i

    Async do |task|
      task.async do
        report_players_rank
      end

      task.async do
        report_games_base_data(games_count)
      end

      task.async do
        report_games_kills_by_means(games_count)
      end
    end
  end

  def report_games_base_data(games_count)
    games = games_count.times.map do |game_id|
      total_kills = @cache_service.hgetall("games_#{game_id + 1}")['total_kills'].to_i
      kills = @cache_service.hgetall("games_#{game_id + 1}_kills").transform_values(&:to_i)
      players = @cache_service.hgetall("games_#{game_id + 1}_players").keys

      {
        "game_#{game_id + 1}" => {
          total_kills:,
          kills:,
          players:
        }
      }
    end

    ap 'report_games_base_data'
    ap games
  end

  def report_games_kills_by_means(games_count)
    kills_by_means = games_count.times.map do |game_id|
      game_kills_by_means = @cache_service.hgetall("games_#{game_id + 1}_kills_by_means")

      {
        "game_#{game_id + 1}" => game_kills_by_means
      }
    end

    ap 'report_games_kills_by_means'
    ap kills_by_means
  end

  def report_players_rank
    players_scores = @cache_service.hgetall('players_scores')

    players_rank = players_scores.map do |player, score|
      {
        score: score.to_i,
        player:
      }
    end

    players_rank.sort_by! { |player| player[:score] }.reverse!

    ap 'report_players_rank'
    ap players_rank
  end
end
