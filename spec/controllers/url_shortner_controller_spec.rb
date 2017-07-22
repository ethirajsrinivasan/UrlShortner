require 'rails_helper'

describe UrlShortnersController do
  
  before do
    sign_in FactoryGirl.create(:user)
  end

  describe "GET index" do
    it "assigns @url_shortners" do
      url_shortner = FactoryGirl.create(:url_shortner)
      get :index
      expect(assigns(:url_shortners)).to eq([url_shortner])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "POST create" do
    it "create url shortner" do
      total_count = UrlShortner.all.count
      post :create, params: {url_shortner: {original_url: "google.com"}}
      expect(UrlShortner.all.count).to eq total_count + 1
    end

    it "renders the index template" do
      post :create, params: {url_shortner: {original_url: "google.com"}}
      expect(response).to render_template("index")
    end

    it "assigns @url_shortners" do
      post :create, params: {url_shortner: {original_url: "google.com"}}
      expect(assigns(:url_shortners)).to eq([UrlShortner.find_by_original_url("google.com")])
    end
  end

  describe "GET show" do
    let(:url_shortner) { FactoryGirl.create(:url_shortner,original_url: "google",sanitized_url: "http://google.com", short_url: "ASDFGH") }
    it "should redirect to original_url" do
      get :show, params: { short_url: url_shortner.short_url }
      expect(response).to redirect_to "http://google.com"
    end

    it "should redirect to original_url" do
      url_shortner_log = UrlShortnerLog.all.count
      get :show, params: { short_url: url_shortner.short_url }
      expect(UrlShortnerLog.all.count).to eq url_shortner_log + 1
    end
  end

  describe "GET stats" do
  
    let(:url_shortner) { FactoryGirl.create(:url_shortner,original_url: "google",sanitized_url: "http://google.com", short_url: "ASDFGH") }
    let(:user) { FactoryGirl.create(:user) }

    it "should proper status" do
      allow_any_instance_of(UrlShortnersController).to receive(:authenticate_request).and_return(user)
      get :stats, params: { id: url_shortner.short_url }
      expect(response.status).to eq 200
    end

    it "should return json response" do
      allow_any_instance_of(UrlShortnersController).to receive(:authenticate_request).and_return(user)
      get :stats, params: { id: url_shortner.short_url }
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["data"]["original_url"]).to eq "google"
      expect(parsed_body["data"]["sanitized_url"]).to eq "http://google.com"
      expect(parsed_body["data"]["total_clicks"]).to eq 0
      expect(parsed_body["data"]["total_users"]).to eq 0
      expect(parsed_body["data"]["user_stats"]).to eq []
    end

    it "should return proper error message" do
      allow_any_instance_of(UrlShortnersController).to receive(:authenticate_request).and_return(user)
      get :stats, params: { id: "ZXCVBN" }
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["error"]).to eq "Short Url Not Found"
    end
  end

  describe "GET fetch_short_url" do

    let(:user) { FactoryGirl.create(:user) }

    it "should proper status" do
      allow_any_instance_of(UrlShortnersController).to receive(:authenticate_request).and_return(user)
      get :fetch_short_url, params: { url: "rails.com" }
      expect(response.status).to eq 200
    end

    it "should return json response" do
      allow_any_instance_of(UrlShortnersController).to receive(:authenticate_request).and_return(user)
      get :fetch_short_url, params: { url: "rails.com" }
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["original_url"]).to eq "rails.com"
      expect(parsed_body["sanitized_url"]).to eq "http://rails.com"
      expect(parsed_body["short_url"]).to eq root_url + UrlShortner.last.short_url
    end
  end

end