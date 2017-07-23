class UrlShortnerLog < ApplicationRecord

  # Associations
  belongs_to :user
  belongs_to :url_shortner

end