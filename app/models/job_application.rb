class JobApplication < ApplicationRecord
  belongs_to :application_status
  has_and_belongs_to_many :tech_stacks

  validates :date_applied, presence: true
  validates :company_name, presence: true
  validates :job_link, presence: true, format: { with: URI.regexp, message: "must be a valid URL" }

  scope :ordered, -> { order(date_applied: :desc) }

  after_initialize :set_default_status, if: :new_record?

  def tech_stack_names
    tech_stacks.pluck(:name).join(", ")
  end

  def tech_stack_names=(names)
    return if names.blank?

    tech_stack_array = names.split(",").map(&:strip).reject(&:blank?)
    self.tech_stacks = tech_stack_array.map { |name| TechStack.find_or_create_by(name: name) }
  end

  private

  def set_default_status
    self.application_status ||= ApplicationStatus.default
  end
end
