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

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by{ |r| r.score }.last.beer
  end

  def favorite_style
    if self.ratings.empty?
      return "No ratings yet"
    else
      return self.ratings.first.beer.style
    end
  end

  def count_scores
    wscore = 0
    lscore = 0
    iscore = 0
    palescore = 0
    porterscore = 0
    self.ratings.each do |r|
      if r.beer.style == "Lager"
        lscore = lscore + r.get_score.to_i
      end
      if r.beer.style == "Pale ale"
        palescore = palescore + r.get_score.to_i
      end
      if r.beer.style == "IPA"
        iscore = iscore + r.get_score.to_i
      end
      if r.beer.style == "Porter"
        porterscore = porterscore + r.get_score.to_i
      end
    end
    arr = [wscore, lscore, iscore, palescore, porterscore]

  end
end