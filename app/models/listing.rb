class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true
  after_create :set_user_host_to_true
  after_destroy :set_user_host_to_false_if_listings_empty

  #Callbacks

  def set_user_host_to_true
    self.host.host = true
    self.host.save
  end

  def set_user_host_to_false_if_listings_empty
    if self.host.listings.empty?
      self.host.host = false
      self.host.save
    end
  end

  #Custom Methods

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
    reservations.where('? BETWEEN reservations.checkin AND reservations.checkout', date).empty?
  end

  def available_at_checkin?(checkin_date)
    date_falls_on_a_reservation?(checkin_date)
  end

  def available_at_checkout?(checkout_date)
    date_falls_on_a_reservation?(checkout_date)
  end


end
