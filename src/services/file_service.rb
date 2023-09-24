# frozen_string_literal: true

# This class privides an interface to interact with files
class FileService
  class << self
    def readlines(path)
      File.readlines(path, chomp: true)
    end
  end
end
