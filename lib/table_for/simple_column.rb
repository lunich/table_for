module TableHelper
  class SimpleColumn < Column # :nodoc:
    def content_for(record)
      called_record = record.send(@attr)
      if @options[:time_format] and called_record.is_a? Time
        called_record = called_record.strftime(@options[:time_format])
      end
      called_record.to_s
    end
  end
end
