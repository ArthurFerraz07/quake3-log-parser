# frozen_string_literal: true

# This class represents a kill
class Kill
  class MeanOfDeath
    MOD_UNKNOWN = 'MOD_UNKNOWN'
    MOD_SHOTGUN = 'MOD_SHOTGUN'
    MOD_GAUNTLET = 'MOD_GAUNTLET'
    MOD_MACHINEGUN = 'MOD_MACHINEGUN'
    MOD_GRENADE = 'MOD_GRENADE'
    MOD_GRENADE_SPLASH = 'MOD_GRENADE_SPLASH'
    MOD_ROCKET = 'MOD_ROCKET'
    MOD_ROCKET_SPLASH = 'MOD_ROCKET_SPLASH'
    MOD_PLASMA = 'MOD_PLASMA'
    MOD_PLASMA_SPLASH = 'MOD_PLASMA_SPLASH'
    MOD_RAILGUN = 'MOD_RAILGUN'
    MOD_LIGHTNING = 'MOD_LIGHTNING'
    MOD_BFG = 'MOD_BFG'
    MOD_BFG_SPLASH = 'MOD_BFG_SPLASH'
    MOD_WATER = 'MOD_WATER'
    MOD_SLIME = 'MOD_SLIME'
    MOD_LAVA = 'MOD_LAVA'
    MOD_CRUSH = 'MOD_CRUSH'
    MOD_TELEFRAG = 'MOD_TELEFRAG'
    MOD_FALLING = 'MOD_FALLING'
    MOD_SUICIDE = 'MOD_SUICIDE'
    MOD_TARGET_LASER = 'MOD_TARGET_LASER'
    MOD_TRIGGER_HURT = 'MOD_TRIGGER_HURT'
    MISSIONPACK = 'MISSIONPACK'
    MOD_NAIL = 'MOD_NAIL'
    MOD_CHAINGUN = 'MOD_CHAINGUN'
    MOD_PROXIMITY_MINE = 'MOD_PROXIMITY_MINE'
    MOD_KAMIKAZE = 'MOD_KAMIKAZE'
    MOD_JUICED = 'MOD_JUICED'
    MOD_GRAPPLE = 'MOD_GRAPPLE'
  end

  attr_reader :game_id, :killer, :killed, :mean_of_death

  def initialize(game_id, killer, killed, mean_of_death)
    @game_id = game_id
    @killer = killer
    @killed = killed
    @mean_of_death = mean_of_death
  end
end
