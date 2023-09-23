# frozen_string_literal: true

# This class represents a log line
class LogLine
  attr_accessor :game, :content

  def to_h
    {
      game:,
      content:
    }
  end
end
