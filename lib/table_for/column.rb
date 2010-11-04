module TableHelper
  class Column # :nodoc:
    attr_reader :title, :html
    delegate :content_tag, :to => :@template

    def initialize(template, obj, ops)
      @template, @attr, @options = template, obj, ops
      @title = @options.delete(:title) || @attr.to_s.humanize.presence || "&nbsp;"
      @html  = @options.delete(:html)  || {}
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
