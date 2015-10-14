require 'expression_helper'
require 'soya/action/canonical'

describe Soya::Action::Canonical do
  hash = {
    :z => 4,
    :m => {
      :o => 3,
      :n => 2
    },
    :a => 1
  }

  context 'when the conditional is true' do
    it 'the hash is recursively sorted by key' do
      expect(Soya::Action::Canonical.new(true, hash).result.to_s).to eql('{:a=>1, :m=>{:n=>2, :o=>3}, :z=>4}')
    end

  end

  context 'when the conditional is true' do
    it 'the hash order is left unchanged' do
      expect(Soya::Action::Canonical.new(false, hash).result.to_s).to eql('{:z=>4, :m=>{:o=>3, :n=>2}, :a=>1}')
    end
  end
end
