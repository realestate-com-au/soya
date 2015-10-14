require 'expression_helper'
require 'soya/expression/boolean'

describe Soya::Expression::Boolean do
  context "given a string 'true'" do
    it "returns match" do
      expect(Soya::Expression::Boolean.new('true')).to be_a_match.with_type(:boolean).with_value(true)
    end
  end

  context "given a string 'false'" do
    it "returns match" do
      expect(Soya::Expression::Boolean.new('false')).to be_a_match.with_type(:boolean).with_value(false)
    end
  end

  mismatches = [ 'TRUE', 'FALSE', 'yes', 'no', '1', '0', '', nil ]
  mismatches.each do |input|
    context "given a string '#{input}'" do
      it "doesn't return a match" do
        expect(Soya::Expression::Boolean.new(input)).to be_a_mismatch
      end
    end
  end
end
