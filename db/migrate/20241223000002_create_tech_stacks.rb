class CreateTechStacks < ActiveRecord::Migration[7.2]
  def change
    create_table :tech_stacks do |t|
      t.string :name, null: false
      t.timestamps
    end
    
    add_index :tech_stacks, :name, unique: true
  end
end 