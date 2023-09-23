# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

Dir['./src/models/*.rb'].each { |file| require "./#{file}" }
Dir['./src/services/*.rb'].each { |file| require "./#{file}" }
Dir['./src/use_cases/*.rb'].each { |file| require "./#{file}" }
Dir['./src/workers/*.rb'].each { |file| require "./#{file}" }

Bundler.require(:test)
