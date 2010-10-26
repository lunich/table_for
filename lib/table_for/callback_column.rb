module TableHelper
  class CallbackColumn < Column # :nodoc:
    def initialize(template, obj, ops)
      super
      @title = @options.delete(:title) || "&nbsp;"
    end
    def content_for(record)
      @attr.call(record)
    end
  end
end
