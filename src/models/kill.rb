# frozen_string_literal: true

# This class represents a kill
class Kill
  attr_reader :game_id, :killer, :killed, :mean_of_death

  def initialize(game_id, killer, killed, mean_of_death)
    @game_id = game_id
    @killer = killer
    @killed = killed
    @mean_of_death = mean_of_death
  end

  def to_h
    {
      game_id:,
      killer:,
      killed:,
      mean_of_death:
    }
  end
end
