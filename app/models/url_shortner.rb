class UrlShortner < ApplicationRecord

  #Constants
  CHAR_POOL = [('a'..'z'),('A'..'Z'),(0..9)].map(&:to_a).flatten
  
  #Callbacks 
  after_create :generate_short_url

  #Relationship
  has_many :url_shortner_logs
  
  def generate_short_url
    self.short_url = UrlShortner.generate_random_token
    until UrlShortner.find_by_short_url(short_url).nil? do
      self.short_url = UrlShortner.generate_random_token
    end
    self.save
  end

  def self.generate_random_token
    CHAR_POOL.sample(6).join 
  end

  def self.sanitize_url(url)
    url.strip!
    url = url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
    url.slice!(-1) if url[-1] == "/"
    url = "http://#{url}"
  end

  def self.fetch_or_create_short_url(original_url)
    sanitized_url = sanitize_url(original_url)
    url_shortner = find_by_sanitized_url(sanitized_url)
    url_shortner.presence || UrlShortner.create(original_url: original_url,sanitized_url: sanitized_url) 
  end

  def stats
    user_click_stats = url_shortner_logs.group("user_id").count
    user_stats = []
    user_click_stats.keys.each do | user_id |
      stats = {}
      user = User.find(user_id)
      stats["user_id"] = user_id
      stats["email"] = user.email
      stats["count"] = user_click_stats[user_id]
      stats["click_stats"] = User.find(user_id).url_shortner_logs.map do |url_shortner_log|
        {"clicked_at": url_shortner_log.created_at,
          "browser": url_shortner_log.browser,
          "version": url_shortner_log.version,
          "platform": url_shortner_log.platform
        }
      end
      user_stats << stats
    end
    { "Original Url": original_url,
      "Sanitized Url": sanitized_url,
      "user_stats": user_stats }
    end

end