module ApplicationHelper
  def safe_external_url(url)
    uri = URI.parse(url)
    return unless uri.is_a?(URI::HTTP)

    uri.to_s
  rescue URI::InvalidURIError
    nil
  end
end
