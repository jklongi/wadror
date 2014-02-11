require 'spec_helper'

describe "Places" do
  before :all do Rails.cache.clear

  end

  it "if one is returned by the API, it is shown at the page" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(:name => "Oljenkorsi") ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple is returned by the API, all are shown at the page" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(:name => "Oljenkorsi"),Place.new(:name => "Kumpulan Pub"), Place.new(:name => "Jotain")  ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Kumpulan Pub"
    expect(page).to have_content "Jotain"
  end

  it "if none is returned by the API, message is displayed" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        []
    )
    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"
  end
end