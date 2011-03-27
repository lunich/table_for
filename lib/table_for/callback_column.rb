module TableHelper
  class CallbackColumn < Column # :nodoc:
    def initialize(template, records, obj, ops)
      super
      @callback = @options.delete(:callback)
    end

    def content_for(record)
      @attr ? @callback.call(record.send(@attr)) : @callback.call(record)
    end
  end
end
