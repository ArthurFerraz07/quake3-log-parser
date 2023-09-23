# frozen_string_literal: true

class ProccessLogLineException < StandardError; end

# This class proccess a log line
# if the line is a kill, will increase the kill count of the current game
class ParseLineUseCase
  class << self
    def parse!
    end
  end
end
