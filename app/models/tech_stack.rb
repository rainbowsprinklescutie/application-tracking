class TechStack < ApplicationRecord
  has_and_belongs_to_many :job_applications

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }
end
