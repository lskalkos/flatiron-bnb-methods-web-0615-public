class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
    self.listings.joins(:reservations).where('(checkin NOT BETWEEN ? AND ?) AND (checkout NOT BETWEEN ? AND ?)', start_date, end_date, start_date, end_date)
  end

  def self.most_res
    all.order(name: :desc).max_by {|city| city.reservations.count}
  end

  def self.highest_ratio_res_to_listings
    all.order(name: :asc).max_by {|city| city.ratio_res_to_listings}
  end

  def ratio_res_to_listings
    reservations.count / listings.count
  end


end

# City.joins(:listings).joins(:reservations).group('cities.id').order('count(reservations.id)/count(listings.id)')
