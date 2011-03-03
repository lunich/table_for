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

    # :content_for
    it ":content_for method should raise error" do
      lambda do
        build_column(klass, :id, :title => "Test").content_for
      end.should raise_error(NoMethodError, "Use SimpleColumn or CallbackColumn")
    end
  end
end
