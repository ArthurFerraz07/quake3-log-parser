# frozen_string_literal: true

Dir['spec/factories/*.rb'].each { |file| require "./#{file}" }

Bundler.require(:test)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

require 'simplecov'
SimpleCov.start
