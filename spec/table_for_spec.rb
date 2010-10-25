require "spec_helper"

describe ActionView::Base do
  let(:view) do
    ActionView::Base.new
  end
  
  let(:users) do
    [
      mock({
        :id => 21,
        :name => "John Smith",
        :email => "tester@example.com",
        :address => "100, Spear Street, NY, USA",
      })
    ]
  end
  
  it "should respond to :table_for" do
    view.should respond_to(:table_for)
  end

  describe ":table_for method" do
    it "should raise if no block given" do
      lambda do
        view.table_for(users)
      end.should raise_error(ArgumentError)
    end
    describe "with callback column" do
      before(:each) do
        @html = view.table_for(users) do
          column :title => "Addr" do |user|
            user.address[0,10]
          end
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead") do |thead|
            thead.should have_selector("tr") do |tr|
              tr.should have_selector("th") do |th|
                th.should contain("Addr")
              end
            end
          end
          table.should have_selector("tbody") do |tbody|
            tbody.should have_selector("tr") do |tr|
              users.each do |user|
                tr.should have_selector("td") do |td|
                  td.should contain(user.address[0,10])
                end
              end
            end
          end
        end
      end
    end
    
    describe "with titled column" do
      before(:each) do
        @html = view.table_for(users) do
          column :email, :title => "Email address"
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead") do |thead|
            thead.should have_selector("tr") do |tr|
              tr.should have_selector("th") do |th|
                th.should contain("Email address")
              end
            end
          end
          table.should have_selector("tbody") do |tbody|
            tbody.should have_selector("tr") do |tr|
              users.each do |user|
                tr.should have_selector("td") do |td|
                  td.should contain(user.email)
                end
              end
            end
          end
        end
      end
    end
    describe "with simple column" do
      before(:each) do
        @html = view.table_for(users) do
          column :name
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead") do |thead|
            thead.should have_selector("tr") do |tr|
              tr.should have_selector("th") do |th|
                th.should contain("Name")
              end
            end
          end
          table.should have_selector("tbody") do |tbody|
            tbody.should have_selector("tr") do |tr|
              users.each do |user|
                tr.should have_selector("td") do |td|
                  td.should contain(user.name)
                end
              end
            end
          end
        end
      end
    end
  end
end
