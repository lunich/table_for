require "core_ex/array"

module TableHelper
  class Table # :nodoc:
    delegate :content_tag, :dom_id, :dom_class, :to => :@template
    
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

    def columns_content(record)
      @columns.map do |col|
        content_tag :td, col.html[:td] do
          col.content_for(record).to_s
        end
      end.join.html_safe
    end

    def records_content
      @records.map do |record|
        content_tag :tr, tr_options(record) do
          columns_content(record)
        end
      end.join.html_safe
    end

    def body
      content_tag :tbody, records_content
    end

    def tr_classes(record, base_class)
      klasses = []
      klasses << dom_class(record) if record.respond_to?(:model_name)
      klasses << base_class if base_class
      stripe = @stripes.next
      klasses << stripe if stripe
      klasses
    end

    def tr_options(record)
      res = @tr_html_options.nil? ? {} : @tr_html_options.clone
      # check if we have proc in :id or :class
      [:id, :class].each do |key|
        res[key] = res[key].call(record) if res.has_key?(key) && res[key].respond_to?(:call)
      end
      # update class
      res[:class] = tr_classes(record, res[:class]).join(" ")
      # update id
      res[:id] ||= dom_id(record) if record.respond_to?(:to_key)
      res
    end
  end
end
