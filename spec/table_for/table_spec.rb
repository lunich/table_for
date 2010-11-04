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
    # column method
    describe ":column method" do
      describe "with argument only" do
        it "should build simple column" do
          table.column(:id)
          table.instance_variable_get(:@columns).last.should be_instance_of(TableHelper::SimpleColumn)
        end
        it "should build column" do
          lambda do
            table.column(:id)
          end.should change(table.instance_variable_get(:@columns), :size).by(1)
        end
      end
      describe "with argument and options" do
        it "should build simple column" do
          table.column(:id, :title => "ID")
          table.instance_variable_get(:@columns).last.should be_instance_of(TableHelper::SimpleColumn)
        end
        it "should build column" do
          lambda do
            table.column(:id, :title => "ID")
          end.should change(table.instance_variable_get(:@columns), :size).by(1)
        end
      end
      describe "with block only" do
        it "should build callback column" do
          table.column { |r| "aaa-#{r}" }
          table.instance_variable_get(:@columns).last.should be_instance_of(TableHelper::CallbackColumn)
        end
        it "should build column" do
          lambda do
            table.column { |r| "aaa-#{r}" }
          end.should change(table.instance_variable_get(:@columns), :size).by(1)
        end
      end
      describe "with block and options" do
        it "should build callback column" do
          table.column(:title => "AAA") { |r| "aaa-#{r}" }
          table.instance_variable_get(:@columns).last.should be_instance_of(TableHelper::CallbackColumn)
        end
        it "should build column" do
          lambda do
            table.column(:title => "AAA") { |r| "aaa-#{r}" }
          end.should change(table.instance_variable_get(:@columns), :size).by(1)
        end
      end
      describe "without block and argument" do
        it "should raise error" do
          lambda do
            table.column
          end.should raise_error(ArgumentError, "Attribute name or block should be given")
        end
      end
      describe "with options only" do
        it "should raise error" do
          lambda do
            table.column(:title => "Title")
          end.should raise_error(ArgumentError, "Attribute name or block should be given")
        end
      end
    end
  end
end
