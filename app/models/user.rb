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
    return nil if ratings.empty?
    array = {}
    ratings.all.each { |rating|
      style = rating.beer.style
      array[style] = [] if array[style].nil?
      array[style] << rating.score
    }

    array.keys.each { |x|
      array[x] = 0 if array[x].empty?
      sum = array[x].reduce(0) { |sum, value| sum + value }
      array[x] = sum / array[x].count
    }

    style = array.keys.first
    uus = array[style]
    array.each { |x, y| style = x if y > uus }

    return style
  end

  
  def favorite_brewery
    return nil if ratings.empty?
    array = {}
    ratings.all.each { |rating|
      brewery = rating.beer.brewery
      array[brewery] = [] if array[brewery].nil?
      array[brewery] << rating.score
    }

    array.keys.each { |x|
      array[x] = 0 if array[x].empty?
      sum = array[x].reduce(0) { |sum, value| sum + value }
      array[x] = sum / array[x].count
    }

    brewery = array.keys.first
    uus = array[brewery]
    array.each { |x, y| brewery = x if y > uus }
    return brewery.name
  end


=begin
  kovakoodattu ja ruma versio mutta toimii
  def count_scores
    wscore = 0
    wcount = 0
    lscore = 0
    lcount = 0
    iscore = 0
    icount = 0
    palescore = 0
    palecount = 0
    porterscore = 0
    portercount = 0
    self.ratings.each do |r|
      if r.beer.style == "Lager"
        lscore = lscore + r.get_score.to_i
        lcount += 1
      end
      if r.beer.style == "IPA"
        iscore = iscore + r.get_score.to_i
        icount += 1
      end
      if r.beer.style == "Weizen"
        wscore = wscore + r.get_score.to_i
        wcount += 1
      end
      if r.beer.style == "Porter"
        porterscore = porterscore + r.get_score.to_i
        portercount += 1
      end
      if r.beer.style == "Pale Ale"
        palescore = palescore + r.get_score.to_i
        palecount += 1
      end
    end

    wscore = wscore / wcount unless wscore == 0
    lscore = lscore / lcount unless lscore == 0
    iscore = iscore / icount unless icount == 0
    palescore = palescore / palecount unless palecount == 0
    porterscore = porterscore / portercount unless portercount == 0

    arr = [wscore, lscore, iscore, palescore, porterscore]
    if arr.max == wscore
        return "Weizen"
    end
    if arr.max == lscore
      return "Lager"
    end
    if arr.max == iscore
      return "IPA"
    end
    if arr.max == palescore
      return "Pale ale"
    end
    if arr.max == porterscore
      return "Porter"
    end
  end
=end

end