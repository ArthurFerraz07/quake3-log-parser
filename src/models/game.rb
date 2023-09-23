# frozen_string_literal: true

# This class represents a game
class Game
  attr_reader :id, :kills, :kills_by_means, :started_at

  def initialize(id, kills, kills_by_means, started_at)
    @id = id
    @kills = kills
    @kills_by_means = kills_by_means
    @started_at = started_at
  end

  def players
    kills.keys
  end

  def to_h
    {
      game_id.to_sym => {
        players:,
        kills:,
        kills_by_means:
      }
    }
  end
end
