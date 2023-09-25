# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

Dir['./src/daemons/*.rb'].each { |file| require "./#{file}" }
Dir['./src/helpers/*.rb'].each { |file| require "./#{file}" }
Dir['./src/models/*.rb'].each { |file| require "./#{file}" }
Dir['./src/services/*.rb'].each { |file| require "./#{file}" }
Dir['./src/use_cases/*.rb'].each { |file| require "./#{file}" }
Dir['./src/workers/*.rb'].each { |file| require "./#{file}" }
Dir['./src/*.rb'].each { |file| require "./#{file}" }

Bundler.require(:default)
Bundler.require(:test)

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::JSONFormatter
  ]
)
