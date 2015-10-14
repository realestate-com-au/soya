require 'expression_helper'
require 'soya/expression/string'

describe Soya::Expression::String do
  matches = [
    { :input => 'abc', :value => 'abc' },
    { :input => '', :value => '' },
    { :input => ' ', :value => ' ' },
    { :input => ' abc ', :value => ' abc ' },
    { :input => '"abc"', :value => 'abc' },
    { :input => '""', :value => '' },
    { :input => '" "', :value => ' ' },
    { :input => '" abc "', :value => ' abc ' },
    { :input => "'abc'", :value => 'abc' },
    { :input => "''", :value => '' },
    { :input => "' '", :value => ' ' },
    { :input => "' abc '", :value => ' abc ' },
    { :input => 'null', :value => 'null' },
    { :input => 'true', :value => 'true' },
    { :input => 'false', :value => 'false' },
    { :input => '123', :value => '123' },
    { :input => '1.23', :value => '1.23' },
    { :input => nil, :value => nil }
  ]
  matches.each do |match|
    input = match[:input]
    value = match[:value]
    context "given a string '#{input}'" do
      it "return a match with #{value}" do
        expect(Soya::Expression::String.new(input)).to be_a_match.with_type(:string).with_value(value)
      end
    end
  end
end
