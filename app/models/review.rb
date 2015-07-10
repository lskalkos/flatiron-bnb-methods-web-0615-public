class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true

  validate :reservation_active
  validate :reservation_finished

  def reservation_active
    if self.reservation
      errors.add(:reservation, "reservation status for this review is pending") unless self.reservation.accepted?
    end
  end

  def reservation_finished
    if self.reservation
      errors.add(:reservation, "checkout for the reservation for this review has not happened") unless self.reservation.finished?
    end
  end


end
