require "action_view"
require "table_for/helper"

module TableHelper
  private
    autoload :Column, "table_for/column"
    autoload :SimpleColumn, "table_for/simple_column"
    autoload :CallbackColumn, "table_for/callback_column"
    autoload :Table, "table_for/table"
end
