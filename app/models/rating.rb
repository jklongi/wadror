class Rating < ActiveRecord::Base
  belongs_to :beer

  def to_s
    "#{beer.name} #{self.score}"
  end

  def get_score
    return self.score
  end
end
