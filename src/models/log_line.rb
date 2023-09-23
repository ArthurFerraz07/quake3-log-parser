# frozen_string_literal: true

# This class represents a log line
class LogLine
  attr_reader :game_id, :content

  def initialize(game_id, content)
    @game_id = game_id
    @content = content
  end

  def to_h
    {
      game:,
      content:
    }
  end
end
