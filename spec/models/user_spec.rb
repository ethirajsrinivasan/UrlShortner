require 'rails_helper'

describe User, type: :model do

  describe "Associations" do
    it "has many url shortner logs" do
      assc = described_class.reflect_on_association(:url_shortner_logs)
      expect(assc.macro).to eq :has_many
    end
  end
  
  it "is valid with valid attributes" do
    expect(User.new(email: "ethiraj@gmail.com", password: "zzzxxx")).to be_valid
  end

  it "is not valid without password" do
    expect(User.new).to_not be_valid
  end

  it "is not valid without password" do
    expect(User.new(email: "ethiraj@gmail.com")).to_not be_valid
  end
end