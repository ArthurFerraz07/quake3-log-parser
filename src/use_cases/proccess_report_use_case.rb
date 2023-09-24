# frozen_string_literal: true

# This class proccess the data collected on input log file and report it
class ProccessReportUseCase
  def initialize(cache_service)
    @cache_service = cache_service
  end

  def proccess!
    games_count = @cache_service.get('games_count').to_i

    players_rank = nil
    games = nil
    kills_by_means = nil

    Async do |task|
      task.async do
        players_rank = report_players_rank
      end

      task.async do
        games = report_games_base_data(games_count)
      end

      task.async do
        kills_by_means = report_games_kills_by_means(games_count)
      end
    end

    report = {
      players_rank:,
      games:,
      kills_by_means:
    }

    ap report

    report
  end

  def report_games_base_data(games_count)
    @games = games_count.times.map do |game_id|
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
  end

  def report_games_kills_by_means(games_count)
    @kills_by_means = games_count.times.map do |game_id|
      game_kills_by_means = @cache_service.hgetall("games_#{game_id + 1}_kills_by_means").transform_values(&:to_i)

      {
        "game_#{game_id + 1}" => game_kills_by_means
      }
    end
  end

  def report_players_rank
    players_scores = @cache_service.hgetall('players_scores')

    @players_rank = players_scores.map do |player, score|
      {
        score: score.to_i,
        player:
      }
    end

    @players_rank.sort_by! { |player| player[:score] }.reverse!
  end
end
