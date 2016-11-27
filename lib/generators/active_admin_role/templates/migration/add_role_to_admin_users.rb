class AddRoleTo<%= model_class_name.tableize.camelize %> < <%= migration_class_name %>
  def change
    add_column :<%= model_class_name.tableize %>, :role, :integer, null: false, limit: 1, default: 0
  end
end
