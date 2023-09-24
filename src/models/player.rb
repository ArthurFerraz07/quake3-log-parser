# frozen_string_literal: true

# This class represents a game
class Player
  attr_reader :name, :score

  def initialize(name, score = nil)
    @name = name
    @score = score || 0
  end

  def to_cache
    {
      name => {
        score:
      }
    }
  end
end
