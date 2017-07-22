FactoryGirl.define do
  factory :url_shortner_log do
    browser "chrome"
    version "55"
    platform "linux"
    url_shortner_id nil
    user_id nil
  end
end