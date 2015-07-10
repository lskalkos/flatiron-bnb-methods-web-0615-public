class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
    self.reservations.where('(checkin BETWEEN ? AND ?) AND (checkout BETWEEN ? AND ?)', start_date, end_date, start_date, end_date)
  end

  def self.highest_ratio_res_to_listings

  end

  def self.most_res
    self.joins(:reservations).group('cities.id').having('max(reservations.id)').limit(1).first
  end

  private

  # City.first.city_openings('2014-05-01', '2014-05-05')
end

