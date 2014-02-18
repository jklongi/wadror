=begin
module RatingAverage
  def average_rating
    count = self.ratings.count('score')
    text = "rating"
    sum = self.ratings.inject(0) { |sum, a| sum += a.score }
    return "Has #{count} #{text.pluralize(count)}, average #{sum/count.to_f}"
  end
end
=end

module RatingAverage
  def average_rating
    ratings.average :score
  end
end