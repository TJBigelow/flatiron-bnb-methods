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
      errors.add(:guest, "cannot book own listing.")
    end
  end

  def is_available
    if self.checkin.present? && self.checkout.present? && !self.listing.is_available?(self.checkin, self.checkout)
      errors.add(:listing, "already booked for at least one of those days.")
    end
  end

  def checkin_before_checkout
    if self.checkin.present? && self.checkout.present?
      if self.checkin > self.checkout
        errors.add(:checkin, "must be prior to checkout.")
      elsif self.checkin == self.checkout
        errors.add(:checkin, "must be on a different day than checkout")
      end
    end
  end
end
