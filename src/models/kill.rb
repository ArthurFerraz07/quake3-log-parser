# frozen_string_literal: true

# This class represents a kill
class Kill
  attr_accessor :game_id, :killer, :killed, :mean

  def to_h
    {
      game_id:,
      killer:,
      killed:,
      mean:
    }
  end
end
