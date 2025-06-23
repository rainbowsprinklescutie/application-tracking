class CreateJobApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :job_applications do |t|
      t.date :date_applied, null: false
      t.string :company_name, null: false
      t.string :job_link, null: false
      t.text :tech_stacks

      t.timestamps
    end
    
    add_index :job_applications, :date_applied
    add_index :job_applications, :company_name
  end
end 