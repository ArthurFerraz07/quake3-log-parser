# frozen_string_literal: true

require './spec/spec_helper'

class Klass
  CONST = { A: 1, B: 2 }.freeze
  INVALID_CONST = 1
end

RSpec.describe ConstantizeHash do
  let(:klass) { Klass }

  describe '#constantize' do
    context 'when const_name is a hash' do
      let(:const_name) { :CONST }
      it 'expects to return a success response' do
        expect(ConstantizeHash.constantize!(klass, const_name)).to eq(true)
      end

      it 'expects to define the constants' do
        ConstantizeHash.constantize!(klass, const_name)
        expect(Klass::A).to eq(1)
        expect(Klass::B).to eq(2)
      end
    end

    context 'when const_name is not a hash' do
      let(:const_name) { :INVALID_CONST }
      it 'expects to return a failure response' do
        expect { ConstantizeHash.constantize!(klass, const_name) }.to raise_error(ConstantizeHashException, 'Constant INVALID_CONST is not a hash')
      end
    end
  end
end
