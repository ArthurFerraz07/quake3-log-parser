# frozen_string_literal: true

class ProccessLogLineException < StandardError; end

# This class parse a a raw kill log to a kill object
class ParseRawKillUseCase
  class << self
    def parse!(log_line)
      kill_info = log_line.content.split(':').last

      killer = extract_killer(kill_info)
      killed = extract_killed(kill_info)
      mean_of_death = extract_mean_of_death(kill_info)

      Kill.new(log_line.game_id, killer, killed, mean_of_death)
    end

    def extract_killer(kill_info)
      kill_info.split('killed').first.strip
    end

    def extract_killed(kill_info)
      kill_info.split('killed').last.split('by').first.strip
    end

    def extract_mean_of_death(kill_info)
      kill_info.split('by').last.strip
    end
  end
end
