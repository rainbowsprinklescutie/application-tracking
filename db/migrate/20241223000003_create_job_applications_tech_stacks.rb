class CreateJobApplicationsTechStacks < ActiveRecord::Migration[7.2]
  def change
    create_table :job_applications_tech_stacks, id: false do |t|
      t.references :job_application, null: false, foreign_key: true
      t.references :tech_stack, null: false, foreign_key: true
    end

    add_index :job_applications_tech_stacks, [ :job_application_id, :tech_stack_id ],
              unique: true, name: 'index_job_applications_tech_stacks_unique'
  end
end
