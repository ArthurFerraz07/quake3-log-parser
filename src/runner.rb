require './app'

ReadLogUseCase.new(ARGV[0] || './inputs/example.txt').read!
