require "spec_helper"

describe ActionView::Base do
  # ActionView::Base instance
  let(:template) do
    ActionView::Base.new
  end
  # users list (stubbed data)
  let(:users) do
    [
      mock({
        :name => "John Smith",
        :email => "smith@matrix.net",
        :address => "100, Spear Street, NY, USA",
      }),
      mock({
        :name => "Thomas Anderson",
        :email => "neo@matrix.net",
        :address => "200, Spear Street, NY, USA",
      }),
      mock({
        :name => "Trinity",
        :email => "trinity@matrix.net",
        :address => "300, Spear Street, NY, USA",
      }),
      mock({
        :name => "Morpheus",
        :email => "morpheus@matrix.net",
        :address => "400, Spear Street, NY, USA",
      })
    ]
  end
  # check if method available
  it "should respond to :table_for" do
    template.should respond_to(:table_for)
  end
  # main method
  describe ":table_for method" do
    # <%= table_for @users %>
    it "should raise if no block given" do
      lambda do
        template.table_for(users)
      end.should raise_error(ArgumentError)
    end
    # <%= table_for @users do %>
    #   <% column :name %>
    # <% end %>
    describe "with simple column" do
      before(:each) do
        @html = template.table_for(users) do
          column :name
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr/th") do |th|
            th.should contain("Name")
          end
          table.should have_selector("tbody/tr") do |tr|
            users.each do |user|
              tr.should have_selector("td") do |td|
                td.should contain(user.name)
              end
            end
          end
        end
      end
    end
    # <%= table_for @users do %>
    #   <% columns :name, :email, :address %>
    # <% end %>
    describe "with columns" do
      before(:each) do
        @html = template.table_for(users) do
          columns :name, :email, :address
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr") do |tr|
            ["Name", "Email", "Address"].each do |field|
              tr.should have_selector("th") do |th|
                th.should contain(field)
              end
            end
          end
        end
      end
    end
    
    # <%= table_for @users, :html => { :id => "users", :class => "simple-table" } do %>
    #   <% column :name %>
    # <% end %>
    describe "with given :html options" do
      before(:each) do
        @html = template.table_for(users, :html => { :id => "users", :class => "simple-table" }) do
          column :name
        end
      end
      it "should render specialized table" do
        @html.should have_selector("table#users.simple-table")
      end
    end
    # <%= table_for @users do %>
    #   <% column :name, :title => "User's name" %>
    # <% end %>
    describe "with titled column" do
      before(:each) do
        @html = template.table_for(users) do
          column :email, :title => "Email address"
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr/th") do |th|
            th.should contain("Email address")
          end
          table.should have_selector("tbody/tr") do |tr|
            users.each do |user|
              tr.should have_selector("td") do |td|
                td.should contain(user.email)
              end
            end
          end
        end
      end
    end
    # <%= table_for @users do %>
    #   <% column :title => "User's name" do |user| %>
    #     <% content_tag :div do %>
    #       <% [user.first_name, user.last_name].join(" ") %>
    #     <% end %>
    #   <% end %>
    # <% end %>
    describe "with callback column" do
      before(:each) do
        @html = template.table_for(users) do
          column :title => "Addr" do |user|
            content_tag :div do
              user.address[0,10]
            end
          end
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr/th") do |th|
            th.should contain("Addr")
          end
          table.should have_selector("tbody/tr") do |tr|
            users.each do |user|
              tr.should have_selector("td/div") do |td|
                td.should contain(user.address[0,10])
              end
            end
          end
        end
      end
    end

    describe "with cycling stripes" do
      before(:each) do
        @html = template.table_for(users, :stripes => %w{s-one s-two s-three}) do
          column :name
        end
      end

      it "should have valid classes" do
        @html.should have_selector("tr.s-one", :count => 2)
        @html.should have_selector("tr.s-two", :count => 1)
        @html.should have_selector("tr.s-three", :count => 1)
      end
    end
  end
end
