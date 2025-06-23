class CreateApplicationStatuses < ActiveRecord::Migration[7.2]
  def change
    create_table :application_statuses do |t|
      t.string :name, null: false
      t.timestamps
    end
    
    add_index :application_statuses, :name, unique: true
  end
end 