#require 'rspec/expectations'

RSpec::Matchers.define :be_a_match do
  match do |actual|
    actual.match? == true and actual.type == @expected_type and actual.value == @expected_value
  end

  chain :with_type do |type|
    @expected_type = type
  end

  chain :with_value do |value|
    @expected_value = value
  end
end

RSpec::Matchers.define :be_a_mismatch do
  match do |actual|
    actual.match? == false
  end
end
