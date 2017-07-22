require 'rails_helper'

describe JsonWebToken  do
  it "have proper class" do
    expect(JsonWebToken.methods(false)).to eq [:encode,:decode]
  end

  describe ".encode" do
    it "should return the auth token" do
      expect(JsonWebToken.encode(user_id: 1)).to_not eq nil
    end
  end

  describe ".decode" do
    it "should return the auth token" do
      token = JsonWebToken.encode(user_id: 1)
      expect(JsonWebToken.decode(token)["user_id"]).to eq 1
    end
  end

end