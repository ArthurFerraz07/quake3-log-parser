# frozen_string_literal: true

# This class represents a log line
class LogLine
  attr_reader :game_id, :content, :last_kill

  def initialize(game_id, content, last_kill: false)
    @game_id = game_id
    @content = content
    @last_kill = last_kill
  end

end
