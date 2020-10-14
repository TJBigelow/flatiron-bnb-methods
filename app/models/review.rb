class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, :reservation, presence: true
  validate :checked_out

  def checked_out
    if self.reservation.present? && self.reservation.checkout > Date.today
      errors.add(:checked_out, "This reservation hasn't ended yet")
    end
  end

end
