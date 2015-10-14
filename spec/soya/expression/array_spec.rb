require 'expression_helper'
require 'soya/expression/array'

describe Soya::Expression::Array do
  matches = [
    { :input => '[]', :value => [] },
    { :input => '[1]', :value => [1] },
    { :input => '[1,2,3]', :value => [1,2,3] },
    { :input => '["a"]', :value => ["a"] },
    { :input => '["a","b"]', :value => ["a","b"] },
  ]
  matches.each do |match|
    input = match[:input]
    value = match[:value]
    context "given a string '#{input}'" do
      it "return a match with #{value}" do
        expect(Soya::Expression::Array.new(input)).to be_a_match.with_type(:array).with_value(value)
      end
    end
  end

  mismatches = [ ' {} ', ' [] ', '', nil ]
  mismatches.each do |input|
    context "given a string '#{input}'" do
      it "doesn't return a match" do
        expect(Soya::Expression::Array.new(input)).to be_a_mismatch
      end
    end
  end
end
