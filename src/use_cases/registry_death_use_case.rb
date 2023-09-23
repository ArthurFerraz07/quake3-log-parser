# frozen_string_literal: true

# This class registry a death on cache
class RegistryDeathUseCase
  def initialize(cache_service)
    @cache_service = cache_service
  end

  def registry!(game_id, killer, player_killed, mean_of_death)
  end
end
