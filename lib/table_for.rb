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
        attr_reader :view, :options, :title, :attr
        
        def initialize(view, obj, ops)
          @view = view
          @options = ops
          @attr = obj
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
          record.send(self.attr)
        end
      end
      
      class CallbackColumn < Column
        def initialize(view, obj, ops)
          super
          @title = @options.delete(:title) || "&nbsp;"
        end
        def content_for(record)
          attr.call(record)
        end
      end
    
      class Table
        attr_reader :options, :view, :columns, :records

        def initialize(view, recs, opts)
          @view = view
          @options = opts
          @columns = []
          @records = recs
        end
        
        def column(*args, &block)
          col_options = args.extract_options!
          unless args.blank?
            attr = args.shift
            self.columns << SimpleColumn.new(self.view, attr, col_options)
          else
            if block_given?
              self.columns << CallbackColumn.new(self.view, block, col_options)
            else
              raise ArgumentError, "Attribute name or block should be given"
            end
          end
        end

        def draw
          self.view.content_tag :table, self.options.delete(:html) do
            head + body
          end
        end
      protected
        def method_missing(method, *args, &proc)
          self.view.send(method, *args, &proc)
        end
      private
        def head
          self.view.content_tag :thead do
            self.view.content_tag :tr do
              self.columns.map do |col|
                self.view.content_tag :th do
                  col.title
                end
              end.join
            end
          end
        end
        
        def body
          self.view.content_tag :tbody do
            self.records.map do |rec|
              self.view.content_tag :tr do
                self.columns.map do |col|
                  self.view.content_tag :td do
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
