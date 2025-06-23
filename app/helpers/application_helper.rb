module ApplicationHelper
  def safe_job_link(job_application)
    return nil unless job_application&.job_link.present?

    # Basic URL validation and sanitization
    begin
      uri = URI.parse(job_application.job_link.strip)
      return nil unless %w[http https].include?(uri.scheme)

      # Additional security checks
      return nil if uri.host.nil? || uri.host.empty?

      # Return the validated URL
      job_application.job_link.strip
    rescue URI::InvalidURIError, ArgumentError
      nil
    end
  end
end
