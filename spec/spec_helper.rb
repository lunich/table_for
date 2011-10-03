require "table_for_collection"
require "webrat"

def build_column(klass, arg, options = {})
  klass.new(template, mock(:test), arg, options)
end

# Column instance methods
shared_examples_for "Column class instance" do
  # Check are methods present
  describe "should have method", :shared => true do
    [:title, :html, :content_for, :content_tag].each do |method|
      it ":#{method}" do
        build_column(klass, :id).should respond_to(method)
      end
    end
  end
  # :html
  describe ":html method" do
    it "should success if :html option is empty" do
      build_column(klass, :id).html.should eq({})
    end
    it "should success if :html option is given" do
      build_column(klass, :id, :html => { :class => "some-class" }).html.should eq(:class => "some-class")
    end
  end
  # :draw_title
  describe ":draw_title method should render" do
    it "valid th" do
      col = build_column(klass, :id, :title => "Test", :html => {
        :th => {
          :class => "some-class",
          :width => "50%",
        }
      })
      html = col.draw_title
      html.should have_selector("th.some-class[@width='50%']") do |th|
        th.should contain(col.title)
      end
    end
  end
end

class User < OpenStruct
  extend ActiveModel::Naming

  def id
    @id
  end
end

RSpec.configure do |config|
  config.include(Webrat::Matchers)
end
