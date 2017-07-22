require "rails_helper"

describe AuthenticationController do

  describe "GET authenticate" do
    let(:user) { FactoryGirl.create(:user) }

    it "should return the auth token" do
      get :authenticate, params: {email: user.email, password: user.password}
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["auth_token"]).to_not eq nil
    end

    it "should return the auth token" do
      get :authenticate, params: {email: user.email, password: "zxcvbn"}
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["error"]).to_not eq nil
    end
  end

end