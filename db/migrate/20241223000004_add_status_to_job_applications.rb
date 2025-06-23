class AddStatusToJobApplications < ActiveRecord::Migration[7.2]
  def change
    add_reference :job_applications, :application_status, null: false, foreign_key: true, default: 1
  end
end
