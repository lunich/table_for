require 'spec_helper'

describe TableHelper::Table do
  # ActionView::Base instance
  let(:template) do
    ActionView::Base.new
  end
  # users list (stubbed data)
  let(:users) do
    [
      User.new(:id => 1,
               :name => "John Jackson",
               :email => "john.jackson@example.com",
               :address => "100, Spear Street, LA, USA"),
      User.new(:id => 2,
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
    # :column method
    describe ":column method" do
      describe "with argument only" do
        it "should build simple column" do
          col = table.column(:id)
          last = table.instance_variable_get(:@columns).last
          last.should be_instance_of(TableHelper::SimpleColumn)
          last.should eq(col)
        end
        it "should build column" do
          lambda do
            table.column(:id)
          end.should change(table.instance_variable_get(:@columns), :size).by(1)
        end
      end
      describe "with argument and options" do
        it "should build simple column" do
          col = table.column(:id, :title => "ID")
          last = table.instance_variable_get(:@columns).last
          last.should be_instance_of(TableHelper::SimpleColumn)
          last.should eq(col)
        end
        it "should build column" do
          lambda do
            table.column(:id, :title => "ID")
          end.should change(table.instance_variable_get(:@columns), :size).by(1)
        end
      end
      describe "with block only" do
        it "should build callback column" do
          col = table.column { |r| "aaa-#{r}" }
          last = table.instance_variable_get(:@columns).last
          last.should be_instance_of(TableHelper::CallbackColumn)
          last.should eq(col)
        end
        it "should build column" do
          lambda do
            table.column { |r| "aaa-#{r}" }
          end.should change(table.instance_variable_get(:@columns), :size).by(1)
        end
      end
      describe "with block and options" do
        it "should build callback column" do
          col = table.column(:title => "AAA") { |r| "aaa-#{r}" }
          last = table.instance_variable_get(:@columns).last
          last.should be_instance_of(TableHelper::CallbackColumn)
          last.should eq(col)
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
    # :columns method
    describe ":columns method" do
      it "should create columns by attributes" do
        attrs = [:id, :name, :email]
        res = nil
        lambda do
          res = table.columns *attrs
        end.should change(table.instance_variable_get(:@columns), :size).by(attrs.size)
        res.should be_instance_of(Array)
        res.size.should eq(attrs.size)
      end
      it "should raise if no arguments given" do
        lambda do
          table.columns
        end.should raise_error(ArgumentError, "At least one attribute name should be given")
      end
    end
    # :draw method
    describe ":draw method" do
      describe "for simple table" do
        before(:each) do
          @attr = :id
          table = build_table
          @col = table.column(@attr)
          @html = table.draw
        end
        describe "should render table" do
          it { @html.should have_selector("table") }
          describe "thead" do
            it { @html.should have_selector("table/thead") }
            describe "tr" do
              it { @html.should have_selector("table/thead/tr") }
              describe "th" do
                it "should contain valid title" do
                  @html.should have_selector("table/thead/tr/th") do |th|
                    th.should contain(@col.title)
                  end
                end
              end
            end
          end
          describe "tbody" do
            it { @html.should have_selector("table/tbody") }
          end
        end
      end
    end
  end
protected
  def build_table(options = {})
    TableHelper::Table.new(template, users, options)
  end
end
