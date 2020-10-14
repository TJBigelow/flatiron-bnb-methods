class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  before_create :make_host
  after_destroy :clear_host

  def average_review_rating
    self.reviews.sum {|review| review.rating}.to_f / self.reviews.length.to_f
  end

  private

  def make_host
    host = self.host
    host.host = true
    host.save
  end

  def clear_host
    host = self.host
    host.host = false if host.listings.length == 0
    host.save
  end


end
