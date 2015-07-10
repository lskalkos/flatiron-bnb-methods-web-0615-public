class User < ActiveRecord::Base
  #Host user stuff
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :guests, through: :reservations

  #Guest user stuff
  has_many :trips, :class_name => "Reservation", :foreign_key => 'guest_id'
  has_many :hosts, through: :trips
  has_many :reviews, :foreign_key => 'guest_id'

  def host_reviews
    self.listings.map{ |listing| listing.reviews }.flatten
  end


end
