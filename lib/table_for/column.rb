module TableHelper
  class Column # :nodoc:
    attr_reader :title, :html
    delegate :content_tag, :to => :@template

    def initialize(template, records, obj, ops={})
      @template, @attr, @options = template, obj, ops

      @title = if @options[:title]
        @options.delete(:title)
      elsif @attr.nil?
        "&nbsp;"
      elsif records.class.respond_to?(:human_attribute_name)
        records.class.human_attribute_name(@attr.to_s)
      elsif @attr.to_s.respond_to?(:humanize)
        @attr.to_s.humanize
      else
        @attr.to_s.capitalize
      end

      @html  = @options.delete(:html)  || {}
      @html.merge!({:th => { :width => @options.delete(:width) }}) if @options[:width]
    end

    def content_for
      raise NoMethodError, "Use SimpleColumn or CallbackColumn"
    end

    def draw_title
      content_tag :th, @html[:th] do
        @title
      end
    end
  end
end
