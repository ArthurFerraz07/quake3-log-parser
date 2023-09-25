# frozen_string_literal: true

class ConstantizeHashException < StandardError; end

# This class transforms a constant hash into a class constant
class ConstantizeHash
  class << self
    def constantize!(klass, const_name)
      hash = klass.const_get(const_name)
      raise ConstantizeHashException, "Constant #{const_name} is not a hash" unless hash.is_a?(Hash)

      hash.each do |key, value|
        next if klass.const_defined?(key)

        klass.const_set(key, value)
      end

      true
    end
  end
end
