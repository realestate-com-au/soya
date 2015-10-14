require 'soya/path'

describe Soya::Path do
  context "given an empty string" do
    it "returns an empty list" do
      expect(Soya::Path.new('').components).to eql([])
    end
  end

  context "given 'abc'" do
    it "returns a single element list" do
      expect(Soya::Path.new('abc').components).to eql(['abc'])
    end
  end

  context "given '123'" do
    it "accepts numbers as keys" do
      expect(Soya::Path.new('123').components).to eql(['123'])
    end
  end

  context "given 'a.b.1.2'" do
    it "returns a four element list" do
      expect(Soya::Path.new('a.b.1.2').components).to eql(['a','b','1','2'])
    end
  end

  context "given 'a1Z.2Yb.Xc3.W4d.5eV.fU6'" do
    it "allows for keys mixed with lower-cased, upper-cased and numbers" do
      expect(Soya::Path.new('a1Z.2Yb.Xc3.W4d.5eV.fU6').components).to eql(['a1Z','2Yb','Xc3','W4d','5eV','fU6'])
    end
  end

  context "given 'a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z'" do
    it "returns a 26 element list which isn't infinite, but it's at least that high" do
      expect(Soya::Path.new('a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z').components).to eql(['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'])
    end
  end

  context "given '\"angelic alice\".bitter bob.catatonic_chris.delightful#dave.envious-eve'" do
    it "returns a 5 element list appropriately escaped" do
      expect(Soya::Path.new('"angelic alice".bitter bob.catatonic_chris.delightful#dave.envious-eve').components).to eql(['"angelic alice"','bitter bob','catatonic_chris','delightful#dave','envious-eve'])
    end
  end

  context "given a nil input" do
    it "raises a NoMethodError exception" do
      expect { Soya::Path.new(nil) }.to raise_error(NoMethodError)
    end
  end

  context "given '.'" do
    it "raises a Soya:Error exception" do
      expect { Soya::Path.new('.') }.to raise_error(Soya::Error)
    end
  end

  context "given 'a.'" do
    it "raises a Soya:Error exception" do
      expect { Soya::Path.new('.') }.to raise_error(Soya::Error)
    end
  end

  context "given '.a'" do
    it "raises a Soya:Error exception" do
      expect { Soya::Path.new('.') }.to raise_error(Soya::Error)
    end
  end
end
