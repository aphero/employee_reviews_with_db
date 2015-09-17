require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db.sqlite3'
)

class Employee < ActiveRecord::Base
  belongs_to :department

  def recent_review
    reviews.last
  end

  def satisfactory?
    self.satisfactory
  end

  def give_raise(amount)
    self.update(salary: self.salary + amount)
    self.save
  end

  def give_review(review_text)
    self.review = review_text
    assess_performance

  end

  def assess_performance
    good_terms = [/positive/i, /good/i, /\b(en)?courag(e[sd]?|ing)\b/i, /ease/i, /improvement/i, /quick(ly)?/i, /incredibl[ey]/i, /\bimpress[edving]?{2,3}/i]
    bad_terms = [/\broom\bfor\bimprovement/i, /\boccur(ed)?\b/i, /not/i, /\bnegative\b/i, /less/i, /\bun[a-z]?{4,9}\b/i, /\b((inter)|e|(dis))?rupt[ivnge]{0,3}\b/i]
    good_terms = Regexp.union(good_terms)
    bad_terms = Regexp.union(bad_terms)

    count_good = self.review.scan(good_terms).length
    count_bad = self.review.scan(bad_terms).length

    if count_good > count_bad
      self.update(satisfactory: 'true')
    else
      self.update(satisfactory: 'false')
    end
  end
end
