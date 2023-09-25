# frozen_string_literal: true

# This class is a wrapper to the logger gem
class LoggerService
  class << self
    def log(message)
      p "[#{Time.now}] - #{message}"
    end
  end
end
