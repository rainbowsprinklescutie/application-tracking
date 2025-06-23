module ApplicationHelper
  def safe_job_link(job_application)
    return nil unless job_application.job_link.present?

    # Basic URL validation
    uri = URI.parse(job_application.job_link)
    return nil unless %w[http https].include?(uri.scheme)

    job_application.job_link
  rescue URI::InvalidURIError
    nil
  end
end
