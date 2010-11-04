module TableHelper
  class CallbackColumn < Column # :nodoc:
    def initialize(template, obj, ops)
      super
      @callback = @options.delete(:callback)
    end

    def content_for(record)
      @attr ? @callback.call(record.send(@attr).to_s) : @callback.call(record)
    end
  end
end
