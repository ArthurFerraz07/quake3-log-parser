# frozen_string_literal: true

# This class represents a game
class Game
  attr_reader :name, :total_kills

  def initialize(name, total_kills = nil)
    @name = name
    @total_kills = total_kills || 0
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
