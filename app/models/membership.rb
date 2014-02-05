class Membership < ActiveRecord::Base
  has_many :beerclubs
  has_many :users
end
