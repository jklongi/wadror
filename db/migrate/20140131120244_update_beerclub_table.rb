class UpdateBeerclubTable < ActiveRecord::Migration
  change_table :beerclubs do |t|
    t.remove :user_id
  end
end
