require 'spec_helper'

describe ActionView::Base do
  # ActionView::Base instance
  let(:template) do
    ActionView::Base.new
  end
  # check if method available
  it "should respond to :table_for" do
    template.should respond_to(:table_for)
  end
  # <%= table_for @users %>
  it "should raise if no block given" do
    lambda do
      template.table_for([])
    end.should raise_error(ArgumentError)
  end
  # users list (hashes array)
  context "for hashes array" do
    let(:users) do
      [
        { :hits => 87.0, :id => 1.0 },
        { :hits => 86.0, :id => 5.0 },
        { :hits => 78.0, :id => 6.0 },
        { :hits => 78.0, :id => 3.0 },
      ]
    end
    # <%= table_for @users, :html => { :id => "users", :class => "simple-table" } do %>
    #   <% column :name %>
    # <% end %>
    describe "with given :html options" do
      before(:each) do
        @html = template.table_for(users, :html => { :id => "users", :class => "simple-table" }) do
          column :hits
        end
      end
      it "should render specialized table" do
        @html.should have_selector("table#users.simple-table")
      end
    end
    # <%= table_for @users, :stripes => ["odd", "even"] do %>
    #   <% column :name %>
    # <% end %>
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

    # <%= table_for @users do %>
    #   <% columns :hits, :id %>
    # <% end %>
    describe "with columns" do
      before(:each) do
        @html = template.table_for(users) do
          columns :hits, :id
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr") do |tr|
            ["Id", "Hits"].each do |field|
              tr.should have_selector("th") do |th|
                th.should contain(field)
              end
            end
          end
        end
      end
    end
    describe "with named callback column" do
      before(:each) do
        @html = template.table_for(users) do
          column :id do |id|
            mail_to id
          end
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr/th") do |th|
            th.should contain("Id")
          end
          table.should have_selector("tbody/tr") do |tr|
            users.each do |user|
              tr.should have_selector("td") do |td|
                td.should have_selector("a[@href='mailto:#{user[:id]}']")
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
          column :id
          column :title => "HITS" do |user|
            content_tag :div do
              user[:hits].to_i.to_s
            end
          end
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr/th") do |th|
            th.should contain("HITS")
          end
          table.should have_selector("tbody/tr") do |tr|
            users.each do |user|
              tr.should have_selector("td") do |td|
                td.should contain(user[:id].to_s)
              end
              tr.should have_selector("td/div") do |td|
                td.should contain(user[:hits].to_i.to_s)
              end
            end
          end
        end
      end
    end
    # <%= table_for @users, :stripes => ["odd", "even"], :html => { :tr => { :class => "table-row" } } do %>
    #   <% column :name %>
    # <% end %>
    describe "with tr html" do
      subject { template.table_for(users, :stripes => ["odd", "even"], :html => { :tr => { :class => "table-row", :id => lambda { |f| "user_#{f[:id].to_i}" } } }) do
          column :hits
        end
      }
      it "should have valid classes" do
        should have_selector("tr.odd.table-row", :count => 2)
        should have_selector("tr.even.table-row", :count => 2)
      end
      it "should have valid ids" do
        users.each do |user|
          should have_selector("tr.table-row#user_#{user[:id].to_i}") do |tr|
            tr.should contain(user.hits.to_s)
          end
        end
      end
    end
    # <%= table_for @users do %>
    #   <% column :name, :title => "User's name" %>
    # <% end %>
    describe "with titled column" do
      before(:each) do
        @html = template.table_for(users) do
          column :hits, :title => "user's hits"
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr/th") do |th|
            th.should contain("user's hits")
          end
          table.should have_selector("tbody/tr") do |tr|
            users.each do |user|
              tr.should have_selector("td") do |td|
                td.should contain(user[:hits].to_s)
              end
            end
          end
        end
      end
    end
    # <%= table_for @users do %>
    #   <% column :name %>
    # <% end %>
    describe "with simple column" do
      before(:each) do
        @html = template.table_for(users) do
          column :hits
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr/th") do |th|
            th.should contain("Hits")
          end
          table.should have_selector("tbody/tr") do |tr|
            users.each do |user|
              tr.should have_selector("td") do |td|
                td.should contain(user[:hits].to_s)
              end
            end
          end
        end
      end
    end
    # <%= table_for @users do %>
    #   <% column :name, :html => { :width => "50%" } %>
    # <% end %>
    describe "with column :html options" do
      before(:each) do
        @html = template.table_for(users) do
          column :id, :html => { :td => { :class => "user-id" }, :th => { :width => "50%" }}
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr") do |tr|
            tr.should have_selector("th[@width='50%']")
          end
          table.should have_selector("tbody/tr") do |tr|
            users.each do |user|
              tr.should have_selector("td.user-id") do |td|
                td.should contain(user[:id].to_s)
              end
            end
          end
        end
      end
    end
  end
  # users list (objects array)
  context "for objects array" do
    let(:users) do
      [
        User.new({
          :id => 1209,
          :name => "John Smith",
          :email => "smith@matrix.net",
          :address => "100, Spear Street, NY, USA"
        }),
        User.new({
          :id => 2123,
          :name => "Thomas Anderson",
          :email => "neo@matrix.net",
          :address => "200, Spear Street, NY, USA"
        }),
        User.new({
          :id => 3323,
          :name => "Trinity",
          :email => "trinity@matrix.net",
          :address => "300, Spear Street, NY, USA"
        }),
        User.new({
          :id => 4912,
          :name => "Morpheus",
          :email => "morpheus@matrix.net",
          :address => "400, Spear Street, NY, USA"
        })
      ]
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
    # <%= table_for @users, :stripes => ["odd", "even"] do %>
    #   <% column :name %>
    # <% end %>
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

    # <%= table_for @users do %>
    #   <% columns :name, :email, :address %>
    # <% end %>
    describe "with columns" do
      before(:each) do
        @html = template.table_for(users) do
          columns :id, :name, :email, :address
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr") do |tr|
            ["Id", "Name", "Email", "Address"].each do |field|
              tr.should have_selector("th") do |th|
                th.should contain(field)
              end
            end
          end
        end
      end
    end
    describe "with named callback column" do
      before(:each) do
        @html = template.table_for(users) do
          column :email do |email|
            mail_to email
          end
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr/th") do |th|
            th.should contain("Email")
          end
          table.should have_selector("tbody/tr") do |tr|
            users.each do |user|
              tr.should have_selector("td") do |td|
                td.should have_selector("a[@href='mailto:#{user.email}']")
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
          column :id
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
              tr.should have_selector("td") do |td|
                td.should contain(user.id.to_s)
              end
              tr.should have_selector("td/div") do |td|
                td.should contain(user.address[0,10])
              end
            end
          end
        end
      end
    end
    # <%= table_for @users, :stripes => ["odd", "even"], :html => { :tr => { :class => "table-row" } } do %>
    #   <% column :name %>
    # <% end %>
    describe "with tr html" do
      subject { template.table_for(users, :stripes => ["odd", "even"], :html => { :tr => { :class => "table-row", :id => lambda { |f| "user_#{f.id}" } } }) do
          column :name
        end
      }
      it "should have valid classes" do
        should have_selector("tr.odd.table-row", :count => 2)
        should have_selector("tr.even.table-row", :count => 2)
      end
      it "should have valid ids" do
        users.each do |user|
          should have_selector("tr.table-row#user_#{user.id}") do |tr|
            tr.should contain(user.name)
          end
        end
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
    #   <% column :name, :html => { :width => "50%" } %>
    # <% end %>
    describe "with column :html options" do
      before(:each) do
        @html = template.table_for(users) do
          column :id, :html => { :td => { :class => "user-id" }, :th => { :width => "50%" }}
        end
      end
      it "should render valid HTML" do
        @html.should have_selector("table") do |table|
          table.should have_selector("thead/tr") do |tr|
            tr.should have_selector("th[@width='50%']")
          end
          table.should have_selector("tbody/tr") do |tr|
            users.each do |user|
              tr.should have_selector("td.user-id") do |td|
                td.should contain(user.id.to_s)
              end
            end
          end
        end
      end
    end
  end
end
