require 'expression_helper'
require 'soya/expression/float'

describe Soya::Expression::Float do
  matches = [
    { :input => '0', :value => 0.0 },
    { :input => '-0', :value => 0.0 },
    { :input => '-1', :value => -1.0 },
    { :input => '1', :value => 1.0 },
    { :input => '-9223372036854775807', :value => -9.223372036854775807e18 },
    { :input => '9223372036854775807', :value => 9.223372036854775807e18 },
    { :input => '1.23', :value => 1.23 },
    { :input => '-1.23', :value => -1.23 },
    { :input => '0.03145', :value => 0.03145 },
    { :input => '0.012345678e7', :value => 123456.78 },
    { :input => '0.012345678e+7', :value => 123456.78 },
    { :input => '-12345678E-7', :value => -1.2345678 },
  ]
  matches.each do |match|
    input = match[:input]
    value = match[:value]
    context "given a string '#{input}'" do
      it "return a match with #{value}" do
        expect(Soya::Expression::Float.new(input)).to be_a_match.with_type(:float).with_value(value)
      end
    end
  end

  mismatches = [ 'hello_world', '123abc', ' 123 ', '012', '', nil ]
  mismatches.each do |input|
    context "given a string '#{input}'" do
      it "doesn't return a match" do
        expect(Soya::Expression::Float.new(input)).to be_a_mismatch
      end
    end
  end
end
