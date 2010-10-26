require "spec_helper"

describe TableHelper::Table do
  # ActionView::Base instance
  let(:template) do
    ActionView::Base.new
  end
  # users list (stubbed data)
  let(:users) do
    [
      mock({
        :name => "John Smith",
        :email => "tester@example.com",
        :address => "100, Spear Street, NY, USA",
      })
    ]
  end
  # table instance
  let(:table) do
    TableHelper::Table.new(template, users)
  end
  # check are methods available
  describe "should respond_to" do
    [:columns, :column, :draw, :content_tag].each do |method|
      it "#{method}" do
        table.should respond_to(method)
      end
    end
  end
end