class ApplicationStatus < ApplicationRecord
  has_many :job_applications, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

  def self.default
    find_by(name: "applied") || create!(name: "applied")
  end
end
