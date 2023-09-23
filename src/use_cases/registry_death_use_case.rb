# frozen_string_literal: true

# This class registry a death on cache
class RegistryDeathUseCase
  def initialize(cache_service)
    @cache_service = cache_service
  end

#   When <world> kill a player, that player loses -1 kill score.
# Since <world> is not a player, it should not appear in the list of players or in the dictionary of kills.
# The counter total_kills includes player and world deaths.

  def registry!(kill)
  end

  def handle_killer_stats(killer)
    return if world_kill?(killer)

    cache_service.hincrby("players_#{killer}_", , increment)
  end

  def handle_killed_stats()
  end

  def handle_game_stats()
  end

  def world_kill?(killer)
    killer == '<world>'
  end
end
