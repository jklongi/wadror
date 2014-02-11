require 'spec_helper'

describe "BeermappingApi" do
  before :all do Rails.cache.clear

  end
  it "When HTTP GET returns one entry, it is parsed and returned" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*tampere/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("tampere")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("O'Connell's Irish Bar")
    expect(place.street).to eq("Rautatienkatu 24")
  end

  it "When HTTP GET returns no entries, return empty table" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*nothingisfound/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("nothingisfound")

    expect(places.size).to eq(0)
    place = places.first
    expect(place).to eq(nil)
  end

  it "When HTTP GET returns multiple entries, entries are returned as an array of Place objects" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>1</id><name>Eka</name><status>Eka</status><reviewlink>Eka</reviewlink><proxylink>Eka</proxylink><blogmap>Eka</blogmap><street>Eka</street><city>Eka</city><state>Eka</state><zip>12345</zip><country>Eka</country><phone>12345</phone><overall>12345</overall><imagecount>12345</imagecount></location><location><id>2</id><name>Toka</name><status>Toka</status><reviewlink>Toka</reviewlink><proxylink>Toka</proxylink><blogmap>Toka</blogmap><street>Toka</street><city>Toka</city><state>Toka</state><zip>12345</zip><country>Toka</country><phone>12345</phone><overall>12345</overall><imagecount>12345</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*multiplematches/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("multiplematches")

    expect(places.size).to eq(2)
    place = places.first
    place2 = places.second
    expect(place.name).to eq("Eka")
    expect(place2.name).to eq("Toka")
  end

end