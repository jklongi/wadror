class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password
  validates :username, uniqueness: true,
            length: { minimum: 3, maximum: 15 }

  validates :password, :format => {:with => /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{4,}/,
                                   message: "must be at least 4 characters and include one number and one letter."}

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :beerclubs, through: :memberships

end