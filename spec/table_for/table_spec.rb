require 'spec_helper'

describe TableHelper::Table do
  # ActionView::Base instance
  let(:template) do
    ActionView::Base.new
  end
  # users list (stubbed data)
  let(:users) do
    [
      mock(:id => 1,
           :name => "John Jackson",
           :email => "john.jackson@example.com",
           :address => "100, Spear Street, LA, USA"),
      mock(:id => 2,
           :name => "Jack Johnson",
           :email => "jack.johnson@example.com",
           :address => "12, Brooklin, NY, USA"),
    ]
  end
  # table instance
  let(:table) do
    TableHelper::Table.new(template, users)
  end
  # Instance methods
  describe "An instance" do
    # check are methods available
    describe "should have method" do
      [:columns, :column, :draw, :content_tag].each do |method|
        it "#{method}" do
          table.should respond_to(method)
        end
      end
    end
  end
end