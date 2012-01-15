# encoding: utf-8
require 'spec_helper'

describe TableHelper::Column do
  # ActionView::Base instance
  let(:template) { ActionView::Base.new }
  # TableHelper::Column
  let(:klass) { TableHelper::Column }
  # Instance methods
  describe "an instance" do
    it_should_behave_like "Column class instance"
    # :title
    it ":title method should success" do
      build_column(klass, :id, :title => "Test").title.should eq("Test")
    end

    it ":width method should success" do
      build_column(klass, :id, :width => '20%').draw_title.should eq('<th width="20%">Id</th>')
    end
    
    it "should success with :title_callback option" do
      build_column(klass, :id, :title_callback => lambda { |t| template.link_to(t, "#") }).draw_title.should eq(%{<th><a href="#">Id</a></th>})
    end

    # :content_for
    it ":content_for method should raise error" do
      expect {
        build_column(klass, :id, :title => "Test").content_for
      }.to raise_error(NoMethodError, "Use SimpleColumn or CallbackColumn")
    end
  end

  describe "localization and humanization" do
    it "should translate by human attribute name" do
      @test_record = User.new(:id => 1, :name => 'Chuck')
      @test_record.class.stub!(:human_attribute_name).with("name").and_return("nombre")

      TableHelper::Column.new(template, [@test_record], :name).title.should eq("nombre")
    end

    it "should translate by humanize" do
      build_column(klass, :full_name).title.should eq("Full name") # Active support activated here
    end
  end
end
