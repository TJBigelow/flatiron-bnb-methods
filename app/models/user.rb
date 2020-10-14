class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.listings.each_with_object([]){|l, arr| l.guests.each {|g| arr << g}}
  end

  def hosts
    self.trips.map{|t| t.listing.host}
  end

  def host_reviews
    self.listings.each_with_object([]){|l, arr| l.reviews.each {|r| arr << r}}
  end
end
