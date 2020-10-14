class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :not_host, :is_available, :checkin_before_checkout

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * self.duration
  end

  def not_host
    if self.guest == self.listing.host
      errors.add(:guest_id, "You can't book your own listing.")
    end
  end

  def overlap?(date)
    unavailable = self.listing.reservations.map {|r| {checkin: r.checkin, checkout: r.checkout}}
    unavailable.any?{|range| range[:checkin] <= date && range[:checkout] >= date}
  end

  def is_available
    if self.checkin.present? && self.overlap?(self.checkin)
      errors.add(:checkin, "That checkin date is already booked.")
    elsif self.checkout.present? && self.overlap?(self.checkout)
      errors.add(:checkout, "That checkout date is already booked.")
    end
  end

  def checkin_before_checkout
    if self.checkin.present? && self.checkout.present?
      if self.checkin > self.checkout
        errors.add(:checkin, "Checkin must be prior to checkout.")
      elsif self.checkin == self.checkout
        errors.add(:checkin, "You must book at least one full day.")
      end
    end
  end
end
