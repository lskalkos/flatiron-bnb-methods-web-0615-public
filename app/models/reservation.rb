class Reservation < ActiveRecord::Base
  belongs_to :listing
  has_one :host, through: :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :checkin_before_checkout
  validate :available_at_checkin
  validate :available_at_checkout

  #Boolean Methods

  def accepted?
    self.status == "accepted" ? true : false
  end

  def finished?
    self.checkout < Date.today ? true : false
  end

  def checkin_before_checkout?
    self.checkin < self.checkout ? true : false
  end

  #Custom Attributes

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price*duration
  end

  #Validations

  def available_at_checkin
    if !self.persisted?
      errors.add(:checkin, "unavailable at specified checkin date") unless self.listing.available_at_checkin?(self.checkin)
    end
  end

  def available_at_checkout
    if !self.persisted?
      errors.add(:checkout, "unavailable at specified checkout date") unless self.listing.available_at_checkout?(self.checkout)
    end
  end

  def checkin_before_checkout
    errors.add(:checkin, "invalid checkin") unless self.checkin_before_checkout?
  end

end
