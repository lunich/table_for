module TableHelper
  class Column # :nodoc:
    attr_reader :title, :html
    def initialize(template, obj, ops)
      @template, @attr, @options, @title = template, obj, ops, ""
      @html = @options.delete(:html) || {}
    end

    def content_for
      raise NoMethodError, "Use SimpleColumn or CallbackColumn"
    end
  end
end
