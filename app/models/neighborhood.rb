class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(first_day, last_day)
    first_day = strip_date(first_day)
    last_day = strip_date(last_day)
    self.listings.select do |listing|
      listing.is_available?(first_day, last_day)
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by{|neighborhood| neighborhood.listings.length > 0 ? (neighborhood.total_reservations / neighborhood.listings.length) : 0 }
  end

  def self.most_res
    self.all.max_by{|neighborhood| neighborhood.total_reservations}
  end

  def total_reservations
    self.listings.sum{|listing| listing.reservations.length}
  end

  private

  def strip_date(string)
    Date.strptime(string, '%Y-%m-%d')
  end
end
