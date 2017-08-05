class UrlShortner < ApplicationRecord

  #Constants
  CHAR_POOL = [('a'..'z'),('A'..'Z'),(0..9)].map(&:to_a).flatten

  # Relationship
  has_many :url_shortner_logs

  # Pagination
  self.per_page = 10

  # Validations
  validates_presence_of :original_url, :sanitized_url

  # Class Methods
  def self.generate_random_token
    CHAR_POOL.sample(6).join
  end

  def self.sanitize_url(url)
    url.strip!
    url = url.downcase.gsub(/^(https?:\/\/)|^(www\.)/, "")
    url.slice!(-1) if url[-1] == "/"
    url = "http://#{url}"
  end

  def self.fetch_or_create_short_url(original_url)
    sanitized_url = sanitize_url(original_url)
    url_shortner = find_by_sanitized_url(sanitized_url)
    unless url_shortner
      url_shortner  = UrlShortner.new(original_url: original_url,sanitized_url: sanitized_url)
      url_shortner.generate_short_url
      url_shortner.save
    end
    url_shortner
  end

  # Instance Methods
  def generate_short_url
    self.short_url = UrlShortner.generate_random_token
    while UrlShortner.where(short_url: short_url).exists? do
      self.short_url = UrlShortner.generate_random_token
    end
  end

  def stats
    url_shortner_logs_collection = url_shortner_logs
    user_click_stats = url_shortner_logs_collection.group("user_id").count
    user_stats = []
    user_click_stats.keys.each do | user_id |
      stats = {}
      user = User.find(user_id)
      stats["user_id"] = user_id
      stats["email"] = user.email
      stats["count"] = user_click_stats[user_id]
      stats["click_stats"] = user.url_shortner_logs.where(url_shortner_id: id).map do |url_shortner_log|
        {"clicked_at": url_shortner_log.created_at,
          "browser": url_shortner_log.browser,
          "version": url_shortner_log.version,
          "platform": url_shortner_log.platform
        }
      end
      user_stats << stats
    end
    { original_url: original_url,
      sanitized_url: sanitized_url,
      total_clicks: url_shortner_logs_collection.count,
      total_users: user_click_stats.count,
      user_stats: user_stats }
  end

end