class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)

    self.listings.joins(:reservations).where('(? NOT BETWEEN reservations.checkin AND reservations.checkout) OR (? NOT BETWEEN reservations.checkin AND reservations.checkout)', start_date, end_date)

  end

  def self.most_res
    all.max_by{|neighborhood| neighborhood.reservations.count}
  end

  def ratio_res_to_listings
    if self.listings.count != 0
      self.reservations.count/self.listings.count
    else
      0
    end
  end

  def self.highest_ratio_res_to_listings
    all.max_by{|neighborhood| neighborhood.ratio_res_to_listings}
  end

end
