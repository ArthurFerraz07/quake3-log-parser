# frozen_string_literal: true

# This class registry a death on cache
class RegistryDeathUseCase
  def initialize(cache_service)
    @cache_service = cache_service
  end

  # When <world> kill a player, that player loses -1 kill score.
  # Since <world> is not a player, it should not appear in the list of players or in the dictionary of kills.
  # The counter total_kills includes player and world deaths.
  def registry!(kill)
    handle_killer_stats(kill)
    handle_killed_stats(kill)
    handle_game_stats(kill)
  end

  private

  def handle_killer_stats(kill)
    @cache_service.hincrby("games_#{kill.game_id}_kills_by_means", kill.mean_of_death, 1)
    return if world_kill?(kill.killer)

    @cache_service.hincrby("players_#{kill.killer}", 'score', 1)
    @cache_service.hincrby("games_#{kill.game_id}_kills", kill.killer, 1)
  end

  def handle_killed_stats(kill)
    return unless world_kill?(kill.killer)

    @cache_service.hincrby("players_#{kill.killed}", 'score', -1)
  end

  def handle_game_stats(kill)
    @cache_service.hincrby("games_#{kill.game_id}", 'total_kills', 1)

    registry_player(kill.game_id, kill.killer)
    registry_player(kill.game_id, kill.killed)
  end

  def registry_player(game_id, player)
    return if world_kill?(player)

    registered_players = @cache_service.lrange("games_#{game_id}_players", 0, -1)

    @cache_service.lpush("games_#{game_id}_players", player) unless registered_players.include?(player)
  end

  def world_kill?(killer)
    killer == '<world>'
  end
end
