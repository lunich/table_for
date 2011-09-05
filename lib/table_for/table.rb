require "core_ex/array"

module TableHelper
  class Table # :nodoc:
    delegate :content_tag, :content_tag_for, :to => :@template
    
    def initialize(template, records, options = {})
      @template, @records, @columns = template, records, []
      # table's html options
      @table_html_options = options.delete(:html) || {}
      # trs' html options
      @tr_html_options = @table_html_options.delete(:tr) || {}
      # stripes (cycling)
      @stripes = options.delete(:stripes) || []
      @stripes.extend CoreEx::ArrayIterator
    end

    def columns(*args)
      res = []
      if args.present?
        args.each do |arg|
          res << self.column(arg)
        end
      else
        raise ArgumentError, "At least one attribute name should be given"
      end
      res
    end

    def column(*args, &block)
      col_options = args.extract_options!
      res = nil

      attr = args.shift or nil

      if block_given?
        col_options[:callback] = block
        @columns << (res = CallbackColumn.new(@template, @records, attr, col_options))
      elsif attr
        @columns << (res = SimpleColumn.new(@template, @records, attr, col_options))
      else
        raise ArgumentError, "Attribute name or block should be given"
      end
      res
    end

    def draw
      content_tag :table, @table_html_options do
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
          @columns.map { |col| col.draw_title }.join.html_safe
        end
      end
    end

    def body
      content_tag :tbody do
        @records.map do |rec|
          content_tag_for :tr, rec, tr_options do
            @columns.map do |col|
              content_tag :td, col.html[:td] do
                col.content_for(rec).to_s
              end
            end.join.html_safe
          end
        end.join.html_safe
      end
    end
    
    def tr_options
      res = @tr_html_options.nil? ? {} : @tr_html_options.clone
      html_class = @stripes.next
      unless html_class.nil?
        res[:class] = [res[:class], html_class].compact.join(" ")
      end
      res
    end

  end
end
