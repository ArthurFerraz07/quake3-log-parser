# frozen_string_literal: true

class ConstantizeHashException < StandardError; end

# This class creates class constants given a class and a hash
# The keys of the hash will be the constant names, and the values will be the constant values
# Example:
#   hash = { 'FOO' => 'bar' }
#   ConstantizeHash.constantize!(SomeClass, hash)
#   SomeClass::FOO # => 'bar'
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
