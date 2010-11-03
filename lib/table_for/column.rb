module TableHelper
  class Column # :nodoc:
    attr_reader :title, :html, :html
    def initialize(template, obj, ops)
      @template, @options, @attr, @title = template, ops, obj, ""
      @html = @options.delete(:html) || {}
    end
  
    def content_for
      raise NoMethodError, "Use SimpleColumn or CallbackColumn"
    end
  end
end
