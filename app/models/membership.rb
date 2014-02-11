class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beerclub

  validates :user, uniqueness: { scope: :beerclub,
                                 message: "can't join the same club twice" }
end
