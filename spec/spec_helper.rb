require "table_for_collection"
require "webrat"

def build_column(klass, arg, options = {})
  klass.new(template, arg, options)
end

# Column instance methods
shared_examples_for "Column class instance" do
  # Check are methods present
  describe "should have method", :shared => true do
    [:title, :html, :content_for].each do |method|
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
end

RSpec.configure do |config|
  config.include(Webrat::Matchers)
end
