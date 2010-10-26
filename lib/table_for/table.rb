module TableHelper
  class Table # :nodoc:
    delegate :content_tag, :to => :@template
    
    def initialize(template, records, options = {})
      @template, @records, @options, @columns = template, records, options, []
    end
  
    def columns(*args)
      unless args.blank?
        args.each do |arg|
          self.column(arg)
        end
      else
        raise ArgumentError, "At least one attribute name should be given"
      end
    end
  
    def column(*args, &block)
      col_options = args.extract_options!
      unless args.blank?
        attr = args.shift
        @columns << SimpleColumn.new(@template, attr, col_options)
      else
        if block_given?
          @columns << CallbackColumn.new(@template, block, col_options)
        else
          raise ArgumentError, "Attribute name or block should be given"
        end
      end
    end

    def draw
      content_tag :table, @options.delete(:html) do
        head + body
      end
    end
  protected
    def method_missing(method, *args, &proc)
      @template.send(method, *args, &proc)
    end
  private
    def head
      content_tag :thead do
        content_tag :tr do
          @columns.map do |col|
            content_tag :th do
              col.title
            end
          end.join
        end
      end
    end
  
    def body
      content_tag :tbody do
        @records.map do |rec|
          content_tag :tr do
            @columns.map do |col|
              content_tag :td do
                col.content_for(rec)
              end
            end.join
          end
        end.join
      end
    end
  end
end
