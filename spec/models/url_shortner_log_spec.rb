require 'rails_helper'

describe UrlShortnerLog do

  describe "Associations" do

    let(:url_shortner) { FactoryGirl.create(:url_shortner,original_url: "google.com") }
    let(:user) { FactoryGirl.create(:user) }
    let(:url_shortner_log) { FactoryGirl.create(:url_shortner_log,user_id: user.id,url_shortner_id: url_shortner.id) }

    it "belongs to url shortner" do
      assc = described_class.reflect_on_association(:url_shortner)
      expect(assc.macro).to eq :belongs_to
    end
    it "belongs to user" do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end

    it "should return correct user" do
      expect(url_shortner_log.user).to eq user
    end

    it "should return correct url shortner" do
      expect(url_shortner_log.url_shortner).to eq url_shortner
    end
  end


end