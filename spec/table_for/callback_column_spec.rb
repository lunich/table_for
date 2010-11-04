require 'spec_helper'

describe TableHelper::CallbackColumn do
  # ActionView::Base instance
  let(:template) { ActionView::Base.new }
  # TableHelper::SimpleColumn
  let(:klass) { TableHelper::CallbackColumn }
  # user (stubbed data)
  let(:user) { mock(:id => 12) }
  # call-proc
  let(:given_proc_without_attr) { lambda { |r| "aaa-#{r.id}" }}
  let(:given_proc_with_attr) { lambda { |r| "aaa-#{r}" }}
  # Instance methods
  describe "an instance" do
    it_should_behave_like "Column class instance"
    # :title
    describe ":title method should success" do
      it "if :title option is empty" do
        col = build_column(klass, nil, :callback => given_proc_without_attr)
        col.title.should eq("&nbsp;")
      end
      it "if :title options is set" do
        col = build_column(klass, nil, :callback => given_proc_without_attr, :title => "Some title")
        col.title.should eq("Some title")
      end
      it "if :title options is empty, but attribute is set" do
        col = build_column(klass, :id, :callback => given_proc_with_attr)
        col.title.should eq("Id")
      end
    end

    # :content_for
    it ":content_for method should success without given attribute" do
      col = build_column(klass, nil, :callback => given_proc_without_attr)
      col.content_for(user).should == given_proc_without_attr.call(user)
    end
    it ":content_for method should success with given attribute" do
      col = build_column(klass, :id, :callback => given_proc_with_attr)
      col.content_for(user).should == given_proc_with_attr.call(user.id)
    end
  end
end