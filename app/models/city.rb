class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(first_day, last_day)
    first_day = strip_date(first_day)
    last_day = strip_date(last_day)
    self.listings.select do |listing|
      reservation_ranges = listing.reservations.map do |reservation| 
        {
          checkin: reservation.checkin,
          checkout: reservation.checkout
        }
      end
      reservation_ranges.none? do |range| 
        (range[:checkin] <= last_day && range[:checkout] >= first_day) ||
        (first_day <= range[:checkout] && last_day >= range[:checkin])
      end
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by{|city| city.listings.length > 0 ? (city.total_reservations / city.listings.length) : 0 }
  end

  def self.most_res
    self.all.max_by{|city| city.total_reservations}
  end
  
  def total_reservations
    self.listings.sum{|listing| listing.reservations.length}
  end

  private
  
  def strip_date(string)
    DateTime.strptime(string, '%Y-%m-%d')
  end

end

