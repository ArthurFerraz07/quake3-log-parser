# frozen_string_literal: true

# This class registry a death on cache
class RegistryDeathUseCase
  def initialize(game, player_killer, player_killed, mean_of_death)
    @game = game
    @player_killer = player_killer
    @player_killed = player_killed
    @mean_of_death = mean_of_death
  end

  def registry!
  end
end
