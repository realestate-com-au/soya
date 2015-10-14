require 'expression_helper'
require 'soya/expression/null'

describe Soya::Expression::Null do
  context "given a string 'null'" do
    it 'is a null expression' do
      expect(Soya::Expression::Null.new('null')).to be_a_match.with_type(:null).with_value(nil)
    end
  end

  mismatches = [ 'NULL', 'Null', 'undef', 'nil', '', nil ]
  mismatches.each do |input|
    context "given a string '#{input}'" do
      it "doesn't return a match" do
        expect(Soya::Expression::Null.new(input)).to be_a_mismatch
      end
    end
  end
end
