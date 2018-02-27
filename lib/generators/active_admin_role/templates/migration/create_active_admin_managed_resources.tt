class CreateActiveAdminManagedResources < <%= migration_class_name %>
  def change
    create_table :active_admin_managed_resources do |t|
      t.string :class_name, null: false
      t.string :action,     null: false
      t.string :name

      t.timestamp null: false
    end

    add_index :active_admin_managed_resources, [:class_name, :action, :name], unique: true, name: "active_admin_managed_resources_index"
  end
end
