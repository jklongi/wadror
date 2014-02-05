require 'spec_helper'
include OwnTestHelper

describe "Beers page" do
  let!(:user) { FactoryGirl.create :user }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "new page exists" do
    visit new_beer_path
    expect(page).to have_content 'New beer'
  end

  it "new beer can be created" do
    visit new_beer_path
    fill_in('beer_name', with:'Olut')
    select('Weizen', from:'beer_style')
    select('Koff', from:'beer_brewery_id')
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.from(0).to(1)
  end

  it "invalid beer is not added to db" do
    visit new_beer_path
    fill_in('beer_name', with:'')
    select('Weizen', from:'beer_style')
    select('Koff', from:'beer_brewery_id')
    expect{
      click_button('Create Beer')
    }.to_not change{Beer.count}.to eq(0)
    expect(current_path).to eq(beers_path)
    expect(page).to have_content 'error'

  end


=begin
  describe "new beer" do
    visit new_beer_path
    fill_in('name', with:'Olut')
    select('Weizen', from:'style')
    select('Koff', from:'brewery_id')
    expect{
      click_button('Create Beer')
    }.to change{beer.count}.by(1)
  end
=end

end
