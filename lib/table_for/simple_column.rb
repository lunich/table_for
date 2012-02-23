module TableHelper
  class SimpleColumn < Column # :nodoc:
    def content_for(record)
      called_record = record.kind_of?(Hash) ? record[@attr] : record.send(@attr)

      if @options[:attr] && called_record.respond_to?(@options[:attr])
        called_record = called_record.send(@options[:attr])
      end

      if @options[:default] && called_record.nil?
        called_record = @options[:default]
      end

      if @options[:time_format] and called_record.is_a? Time
        called_record = called_record.strftime(@options[:time_format])
      end
      called_record.to_s
    end
  end
end
