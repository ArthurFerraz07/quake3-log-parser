# frozen_string_literal: true

Dir['spec/factories/*.rb'].each { |file| require "./#{file}" }
Dir['models/*.rb'].each { |file| require "./#{file}" }
Dir['services/*.rb'].each { |file| require "./#{file}" }
Dir['use_cases/*.rb'].each { |file| require "./#{file}" }
Dir['workers/*.rb'].each { |file| require "./#{file}" }

Bundler.require(:test)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

require 'simplecov'
SimpleCov.start
