require 'spec_helper'

include OwnTestHelper

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end

  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "page" do
    let! (:user2) { FactoryGirl.create :user2 }
    let! (:user3) { FactoryGirl.create :user3 }
    let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
    let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
    let!(:rating) { FactoryGirl.create :rating, score: 10, beer_id: beer1.id, user_id: user2.id}
    let!(:rating2) { FactoryGirl.create :rating, score: 20, beer_id: beer1.id, user_id: user2.id}
    let!(:rating3) { FactoryGirl.create :rating, score: 30, beer_id: beer1.id, user_id: user3.id}


    it "ratings are showing" do
      visit user_path(user2)
      expect(page).to have_content 'Jussi'
      expect(page).to have_content 'Has 2 ratings'
      expect(page).to have_content 'iso 3'
      expect(page).to have_content '10'
      expect(page).to have_content '20'
      expect(page).to_not have_content '30'
    end

    it "ratings can be deleted" do
      visit user_path(user2)
      sign_in(username:"Jussi", password:"Foobar1")
      expect(user2.ratings.count).to eq(2)
      page.first(:link, "delete").click
      expect(user2.ratings.count).to eq(1)
    end

    it "has favourite style" do
      visit user_path(user2)
      expect(page).to have_content 'Favourite style:'
      expect(page).to have_content 'Lager'
    end

    it "has favourite brewery" do
      visit user_path(user2)
      expect(page).to have_content 'Favourite brewery:'
      expect(page).to have_content 'Koff'
    end

  end

end