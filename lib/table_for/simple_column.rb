module TableHelper
  class SimpleColumn < Column # :nodoc:
    def initialize(template, obj, ops)
      super
      @title = @options.delete(:title) || @attr.to_s.humanize || "&nbsp;"
    end

    def content_for(record)
      record.send(@attr).to_s
    end
  end
end
