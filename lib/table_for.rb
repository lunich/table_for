require "action_view"

module ActionView
  module Helpers
    module TableHelper
      # Creates a table by given collection.
      #
      # Example:
      #
      # <tt>table_for @users do
      #   column :name
      #   column :address, :title => "Addr."
      #   column :title => "Actions" do |user|
      #     link_to "Show", user
      #   end
      # end</tt>
      #
      def table_for(records, *args, &proc)
        raise ArgumentError, "Missing block" unless block_given?
        options = args.extract_options!
        raise ArgumentError, "Records should be array" unless Array === records
        t = Table.new(self, records, options)
        t.instance_eval(&proc)
        t.draw
      end
    private
      class Column
        attr_reader :title
        def initialize(view, obj, ops)
          @view, @options, @attr, @title = view, ops, obj, ""
        end
        
        def content_for
          raise NoMethodError, "Use SimpleColumn or CallbackColumn"
        end
      end
      
      class SimpleColumn < Column
        def initialize(view, obj, ops)
          super
          @title = @options.delete(:title) || @attr.to_s.humanize || "&nbsp;"
        end
        def content_for(record)
          record.send(@attr)
        end
      end
      
      class CallbackColumn < Column
        def initialize(view, obj, ops)
          super
          @title = @options.delete(:title) || "&nbsp;"
        end
        def content_for(record)
          @attr.call(record)
        end
      end
    
      class Table
        def initialize(view, recs, opts)
          @view = view
          @options = opts
          @columns = []
          @records = recs
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
            @columns << SimpleColumn.new(@view, attr, col_options)
          else
            if block_given?
              @columns << CallbackColumn.new(@view, block, col_options)
            else
              raise ArgumentError, "Attribute name or block should be given"
            end
          end
        end

        def draw
          @view.content_tag :table, @options.delete(:html) do
            head + body
          end
        end
      protected
        def method_missing(method, *args, &proc)
          @view.send(method, *args, &proc)
        end
      private
        def head
          @view.content_tag :thead do
            @view.content_tag :tr do
              @columns.map do |col|
                @view.content_tag :th do
                  col.title
                end
              end.join
            end
          end
        end
        
        def body
          @view.content_tag :tbody do
            @records.map do |rec|
              @view.content_tag :tr do
                @columns.map do |col|
                  @view.content_tag :td do
                    col.content_for(rec)
                  end
                end.join
              end
            end.join
          end
        end
      end
    end
  end
end

ActionView::Base.class_eval {
  include ActionView::Helpers::TableHelper
}
