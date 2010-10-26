require 'core_ex/array'

describe Array do
  describe "when non-empty" do
    let(:array) do
      [1, 2, 3]
    end
    before(:each) do
      array.extend CoreEx::ArrayIterator
    end
    it "should have :next method" do
      array.should respond_to(:next)
    end
    describe "method :next" do
      it "should return valid values" do
        array.next.should == 1
        array.next.should == 2
        array.next.should == 3
        array.next.should == 1
      end
    end
  end
  describe "when empty" do
    let(:array) do
      []
    end
    before(:each) do
      array.extend CoreEx::ArrayIterator
    end
    it "should have :next method" do
      array.should respond_to(:next)
    end
    it "should return nil" do
      array.next.should be_nil
      array.next.should be_nil
      array.next.should be_nil
    end
  end
end