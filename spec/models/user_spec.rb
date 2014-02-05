require 'spec_helper'

describe User do

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq("Has 2 ratings, average 15.0")
    end
  end

  describe "is not saved with improper password" do

    it "improper password not saved, too short" do
      user = User.create username:"Jussi", password: "jo", password_confirmation:"jo"
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "improper password not saved, no number" do
      user = User.create username:"Jussi", password: "Joo", password_confirmation:"Joo"
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "improper password not saved, no capitals" do
      user = User.create username:"Jussi", password: "joo1", password_confirmation:"joo1"
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "improper password not saved, no capitals, no numbers" do
      user = User.create username:"Jussi", password: "joo", password_confirmation:"joo"
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  def create_beer_with_rating(score, user)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(*scores, user)
    scores.each do |score|
      create_beer_with_rating(score, user)
    end
  end
end