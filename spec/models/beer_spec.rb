require 'spec_helper'

describe Beer do
  it "has the username set correctly" do
    beer = Beer.new name:"Olut"
    beer.name.should == "Olut"
  end

  it "has username and style correctly" do
    beer = Beer.create name:"Olut", style:"Lager"
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)

  end

  it "is not saved without a style" do
    beer = Beer.create name:"Olut"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a name" do
    beer = Beer.create style:"Lager"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it"huomoi raportissa nämä" do
    Beerclub
    BeerclubsController
    RatingsController
    Membership
    MembershipsController

  end

end

