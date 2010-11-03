require 'spec_helper'

describe TableHelper::CallbackColumn do
  # ActionView::Base instance
  let(:template) { ActionView::Base.new }
  # TableHelper::SimpleColumn
  let(:klass) { TableHelper::CallbackColumn }
  # user (stubbed data)
  let(:user) { mock(:id => 12) }
  # call-proc
  let(:given_proc) { lambda { |r| "aaa-#{r.id}" }}
  # Instance methods
  describe "an instance" do
    it_should_behave_like "Column class instance"
    # :title
    describe ":title method should success" do
      it "if :title option is empty" do
        col = build_column(klass, given_proc)
        col.title.should eq("&nbsp;")
      end
      it "if :title options is set" do
        col = build_column(klass, given_proc, :title => "Some title")
        col.title.should eq("Some title")
      end
    end
    # :content_for
    it ":content_for method should success" do
      col = build_column(klass, given_proc)
      col.content_for(user).should == given_proc.call(user)
    end
  end
end