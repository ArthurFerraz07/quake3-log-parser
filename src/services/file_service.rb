# frozen_string_literal: true

# This class privides an interface to interact with files
class FileService
  class << self
    def openf(path)
      File.open(path)
    end

    def readlines(path)
      openf(path).readlines
    end
  end
end
