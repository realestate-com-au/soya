require 'expression_helper'
require 'soya/expression/integer'

describe Soya::Expression::Integer do
  matches = [
    { :input => '0',  :value => 0 },
    { :input => '-0', :value => 0 },
    { :input => '-1', :value => -1 },
    { :input => '1',  :value => 1 },
    { :input => '-9223372036854775807',  :value => -9223372036854775807 },
    { :input => '9223372036854775807',  :value => 9223372036854775807 },
  ]
  matches.each do |match|
    input = match[:input]
    value = match[:value]
    context "given a string '#{input}'" do
      it "return a match with #{value}" do
        expect(Soya::Expression::Integer.new(input)).to be_a_match.with_type(:integer).with_value(value)
      end
    end
  end

  mismatches = [ '1.23', 'hello_world', '123abc', ' 123 ', '012', '', nil ]
  mismatches.each do |input|
    context "given a string '#{input}'" do
      it "doesn't return a match" do
        expect(Soya::Expression::Integer.new(input)).to be_a_mismatch
      end
    end
  end
end
