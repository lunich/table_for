require 'spec_helper'

describe TableHelper::SimpleColumn do
  # ActionView::Base instance
  let(:template) { ActionView::Base.new }
  # TableHelper::SimpleColumn
  let(:klass) { TableHelper::SimpleColumn }
  # user (stubbed data)
  let(:user) { mock(:id => 12) }
  # Instance methods
  describe "an instance" do
    it_should_behave_like "Column class instance"
    # :title
    describe ":title method should success" do
      it "if :title option is empty" do
        col = build_column(klass, attr = :id)
        col.title.should eq(attr.to_s.humanize)
      end
      it "if :title options is set" do
        col = build_column(klass, :id, :title => "Some title")
        col.title.should eq("Some title")
      end
    end
    # :content_for
    it ":content_for method should success" do
      col = build_column(klass, :id)
      col.content_for(user).should == user.id.to_s
    end
  end
end
