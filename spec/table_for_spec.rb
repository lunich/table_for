require "table_for"
require "spec_helper"

describe ActionView::Base do
  let(:view) do
    ActionView::Base.new
  end
  
  let(:users) do
    s = "user"
    s.stub(:plural => "users", :singular => "user")
    ActionView::Base.stub(:user_path => "/users/1")
    RSpec::Mocks::Mock.stub(:model_name => s)

    [
      mock({
        :id => 21,
        :name => "John Smith",
        :email => "tester@example.com",
        :address => "100, Spear Street, NY, USA",
      })
    ]
  end
  
  it "should raise if no block given" do
    lambda do
      view.table_for(users)
    end.should raise_error(ArgumentError)
  end
  
  it "should respond to :table_for" do
    view.should respond_to(:table_for)
  end

  describe "table_for" do
    before(:each) do
      @html = view.table_for(users) do
        column :name
        column :email, :title => "El. address"
        column :title => "Addr" do |user|
          user.address[0,10]
        end
        column :title => "Actions" do |user|
          link_to "Show", user
        end
      end
    end
    it "should render valid HTML" do
      @html.should have_selector("table") do |table|
        table.should have_selector("thead") do |thead|
          thead.should have_selector("tr") do |tr|
            tr.should have_selector("th") do |th|
              th.should contain("Name")
            end
            tr.should have_selector("th") do |th|
              th.should contain("El. address")
            end
            tr.should have_selector("th") do |th|
              th.should contain("Addr")
            end
          end
        end
        table.should have_selector("tbody") do |tbody|
          tbody.should have_selector("tr") do |tr|
            users.each do |user|
              tr.should have_selector("td") do |td|
                td.should contain(user.name)
              end
              tr.should have_selector("td") do |td|
                td.should contain(user.email)
              end
              tr.should have_selector("td") do |td|
                td.should contain(user.address[0,10])
              end
            end
          end
        end
      end
    end
  end
end
