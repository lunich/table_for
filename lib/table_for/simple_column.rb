module TableHelper
  class SimpleColumn < Column # :nodoc:
    def content_for(record)
      record.send(@attr).to_s
    end
  end
end
