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

  it "should add new beer with valid data" do
    brewery = FactoryGirl.create(:brewery)
    style = FactoryGirl.create(:style)
    visit new_beer_path

    fill_in('beer_name', with:'Test')

    select(style.name, from: 'beer_style_id')
    select(brewery.name, from: 'beer_brewery_id')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end


  it "should not add new beer with invalid data" do
    brewery = FactoryGirl.create(:brewery)
    style = FactoryGirl.create(:style)
    visit new_beer_path

    select(style.name, from: 'beer_style_id')
    select(brewery.name, from: 'beer_brewery_id')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)

    expect(current_path).to eq(beers_path)
    expect(page).to have_content "Name can't be blank"
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
