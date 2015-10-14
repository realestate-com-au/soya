require 'soya/action/insertion'

describe Soya::Action::Insertion do
  hash = {
    'a' => {
      'b' => {
        'c' => 1,
        'd' => 2
      },
      'e' => {
        'f' => 3,
        'g' => 4
      },
      'h' => [5,6,7,8]
    }
  }

  context 'insert an empty prefix' do
    it 'leaves the input hash unchanged' do
      expect(Soya::Action::Insertion.new('', hash).result).to eql(hash)
    end
  end

  context 'insert a subtree' do
    it 'return everything underneath x.y' do
      expect(Soya::Action::Insertion.new('x.y', hash).result).to eql({'x'=>{'y'=>hash}})
    end
  end
end
