require 'soya/action/deletion'

describe Soya::Action::Deletion do
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

  context 'empty deletion' do
    it 'leaves the input hash unchanged' do
      expect(Soya::Action::Deletion.new([], hash).result).to eql(hash)
    end
  end

  context 'simple key deletion' do
    it 'return all other hash elements' do
      expect(Soya::Action::Deletion.new(['a.b.c'], hash).result).to eql({'a'=>{'b'=>{'d'=>2},'e'=>{'f'=>3,'g'=>4},'h'=>[5,6,7,8]}})
    end
  end

  context 'multiple key and array deletion' do
    it 'return all other elements' do
      expect(Soya::Action::Deletion.new(['a.e','a.b.d','a.h.[2]'], hash).result).to eql({'a'=>{'b'=>{'c'=>1},'h'=>[5,6,8]}})
    end
  end

  context 'given an invalid key' do
    it "raises a Soya:Error exception" do
      expect { Soya::Action::Deletion.new(['z'], hash) }.to raise_error(Soya::Error)
    end
  end
end
