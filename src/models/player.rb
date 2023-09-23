# frozen_string_literal: true

# This class represents a game
class Game
  attr_accessor :total_kills, :name

  def initialize
    @total_kills = 0
  end

  def to_cache
    {
      name =>
      {
        total_kills:
      }
    }
  end
end
