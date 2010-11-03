require "action_view"
require "table_for_collection/helper"

module TableHelper
  private
    autoload :Column, "table_for_collection/column"
    autoload :SimpleColumn, "table_for_collection/simple_column"
    autoload :CallbackColumn, "table_for_collection/callback_column"
    autoload :Table, "table_for_collection/table"
end
