class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  after_create :set_user_host_to_true
  after_destroy :set_user_host_to_false

  def set_user_host_to_true
    self.host.host = true
    self.host.save
  end

  def set_user_host_to_false
    if self.host.listings.empty?
      self.host.host = false
      self.host.save
    end
  end

  def number_of_reviews
    self.reviews.size.to_f
  end

  def sum_of_review_ratings
    self.reviews.pluck(:rating).inject(:+).to_f
  end

  def average_review_rating
    sum_of_review_ratings/number_of_reviews
  end

  def date_falls_on_a_reservation?(date)
    reservations = Listing.joins(:reservations).where('? BETWEEN reservations.checkin AND reservations.checkout', date)
    !reservations.empty?
  end

  def available_at_checkin?(checkin_date)
    !date_falls_on_a_reservation?(checkin_date)
  end

  def available_at_checkout?(checkout_date)
    !date_falls_on_a_reservation?(checkout_date)
  end



end
