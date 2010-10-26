require 'core_ex/array'

describe Array do
  let(:array) do
    [1, 2, 3]
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