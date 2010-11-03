require "core_ex/array"

module TableHelper
  class Table # :nodoc:
    delegate :content_tag, :to => :@template

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
          content_tag(:tr, tr_options) do
            @columns.map do |col|
              content_tag :td, col.html do
                col.content_for(rec).to_s
              end
            end.join
          end
        end.join
      end
    end
    
    def tr_options
      res = @tr_html_options.nil? ? {} : @tr_html_options.clone
      html_class = @stripes.next
      unless html_class.nil?
        if res.has_key?(:class)
          res[:class] += " " + html_class
        else
          res.merge!({ :class => html_class })
        end
      end
      res
    end

  end
end
