require 'soya/action/definition'

describe Soya::Action::Definition do
  context 'empty definition' do
    it 'leaves the input hash unchanged' do
      hash = double('hash')
      expect(Soya::Action::Definition.new([], hash).result).to eql(hash)
    end
  end

  context 'simple key definition' do
    it 'return a single-element hash' do
      expect(Soya::Action::Definition.new(['a=1'], {}).result).to eql({'a'=>1})
    end
  end

  context 'multiple definitions, some in subtrees and a variety of expression types' do
    it 'return a complex hash' do
      expected = {
        'a' => 1,
        'b' => true,
        'c' => false,
        'd' => {
            'a' => nil,
            'b' => 3.1415926535,
        },
        'e' => 'hello',
        'f' => 'world',
      }
      input = ['a=1','b=true','c=false','d.a=null','d.b=0.31415926535e1','e="hello"','f=world']
      expect(Soya::Action::Definition.new(input, {'a'=>0}).result).to eql(expected)
    end
  end
end
