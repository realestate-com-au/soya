require 'expression_helper'
require 'soya/expression/object'

describe Soya::Expression::Object do
  matches = [
    { :input => '{}', :value => {} },
    { :input => '{"a":"b"}', :value => {"a" => "b"} },
    { :input => '{"a":"b", "c":"d"}', :value => {"a" => "b", "c" => "d"} },
    { :input => '{"a":"b", "c":"d", "e": {"f":"g","h":"i"}}', :value => {"a" => "b", "c" => "d", "e" => {"f" => "g", "h" => "i"}} },
  ]
  matches.each do |match|
    input = match[:input]
    value = match[:value]
    context "given a string '#{input}'" do
      it "return a match with #{value}" do
        expect(Soya::Expression::Object.new(input)).to be_a_match.with_type(:object).with_value(value)
      end
    end
  end

  mismatches = [ ' {} ', ' [] ', '', nil ]
  mismatches.each do |input|
    context "given a string '#{input}'" do
      it "doesn't return a match" do
        expect(Soya::Expression::Object.new(input)).to be_a_mismatch
      end
    end
  end
end
