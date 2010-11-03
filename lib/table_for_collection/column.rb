module TableHelper
  class Column # :nodoc:
    attr_reader :title
    def initialize(template, obj, ops)
      @template, @options, @attr, @title = template, ops, obj, ""
    end
  
    def content_for
      raise NoMethodError, "Use SimpleColumn or CallbackColumn"
    end
  end
end
