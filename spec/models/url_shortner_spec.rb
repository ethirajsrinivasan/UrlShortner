require 'rails_helper'

describe UrlShortner, type: :model do

  let(:url_shortner) { FactoryGirl.create(:url_shortner) }
  describe "Associations" do
    it "has many url url_shortner_logs" do
      assc = described_class.reflect_on_association(:url_shortner_logs)
      expect(assc.macro).to eq :has_many
    end
  end

  it "is valid with valid attributes" do
    expect(url_shortner).to be_valid
  end

  it "is not valid without original_url" do
    expect(UrlShortner.new).not_to be_valid
    expect(UrlShortner.new(sanitized_url: "http://google.com")).not_to be_valid
  end

  it "is not valid without sanitized_url" do
    expect(UrlShortner.new(original_url: "google.com")).not_to be_valid
  end

  it "is expected to return correct per page parameter" do
    expect(UrlShortner.per_page).to eq 10
  end

  describe "#generate_short_url" do
    it "should generate short url" do
      url_shortner.generate_short_url
      expect(url_shortner.short_url.length).to eq 6
    end
  end

  describe ".generate_random_token" do
    it "should generate random token" do
      expect(UrlShortner.generate_random_token.length).to eq 6
    end
  end

  describe ".sanitize_url" do
    it "should proper sanitize_url" do
      expect(UrlShortner.sanitize_url("pocketmath.com")).to eq "http://pocketmath.com"
      expect(UrlShortner.sanitize_url("https://pocketmath.com")).to eq "http://pocketmath.com"
      expect(UrlShortner.sanitize_url("www.pocketmath.com")).to eq "http://pocketmath.com"
      expect(UrlShortner.sanitize_url("http://pocketmath.com")).to eq "http://pocketmath.com"
      expect(UrlShortner.sanitize_url("pocketmath.com/")).to eq "http://pocketmath.com"
      expect(UrlShortner.sanitize_url("https://pocketmath.com/")).to eq "http://pocketmath.com"
      expect(UrlShortner.sanitize_url("www.pocketmath.com/")).to eq "http://pocketmath.com"
      expect(UrlShortner.sanitize_url("http://pocketmath.com/")).to eq "http://pocketmath.com"
    end
  end

  describe ".fetch_or_create_short_url" do
    before do
      FactoryGirl.create(:url_shortner,original_url: "google.com")
    end
    it "should fetch url shortner" do
      total_count = UrlShortner.all.count
      UrlShortner.fetch_or_create_short_url("google.com")
      expect(UrlShortner.all.count).to eq total_count
    end
    it "should create url shortner" do
      total_count = UrlShortner.all.count
      UrlShortner.fetch_or_create_short_url("yahoo.com")
      expect(UrlShortner.all.count).to eq total_count + 1
    end


    it "should give proper stats" do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:url_shortner_log,user_id: user.id,url_shortner_id: url_shortner.id)
      stats = url_shortner.stats.symbolize_keys
      expect(stats[:original_url]).to eq url_shortner.original_url
      expect(stats[:sanitized_url]).to eq url_shortner.sanitized_url
      expect(stats[:total_users]).to eq 1
      expect(stats[:total_clicks]).to eq 1
      expect(stats[:user_stats].first["user_id"]).to eq user.id
      expect(stats[:user_stats].first["email"]).to eq user.email
      expect(stats[:user_stats].first["count"]).to eq 1
      expect(stats[:user_stats].first["click_stats"].first[:browser]).to eq "chrome"
      expect(stats[:user_stats].first["click_stats"].first[:version]).to eq "55"
      expect(stats[:user_stats].first["click_stats"].first[:platform]).to eq "linux"
      FactoryGirl.create(:url_shortner_log,user_id: user.id,url_shortner_id: url_shortner.id)
      stats = url_shortner.stats.symbolize_keys
      expect(stats[:total_clicks]).to eq 2
    end
  end

end