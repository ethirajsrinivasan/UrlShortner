FactoryGirl.define do
  factory :url_shortner do
    original_url "google.com"
    sanitized_url "http://google.com"
  end

end