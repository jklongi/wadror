require 'spec_helper'
include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq("Has 1 rating, average 15.0")
  end

  it "shows all ratings" do
    FactoryGirl.create :rating, score: 10, beer_id: beer1.id, user_id:user.id
    FactoryGirl.create :rating, score: 20, beer_id: beer2.id, user_id:user.id
    visit ratings_path
    expect(page).to have_content 'List of ratings'
    expect(page). to have_content 'iso 3'
    expect(page). to have_content '10'
    expect(page). to have_content 'Pekka'
    expect(page). to have_content 'Karhu'
    expect(page). to have_content '20'
    expect(page). to have_content 'Pekka'
  end

end