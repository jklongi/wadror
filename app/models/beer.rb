class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    count = 0
    ratings.each do |r|
      count = count +1
    end

    return "Has #{count} ratings, average #{self.ratings.average('score')}"
  end
end
