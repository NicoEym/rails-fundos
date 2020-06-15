class Calendar < ApplicationRecord
  validates :day, presence: true
  has_many :daily_data, dependent: :destroy

  def last_day_of_month?


    day.month != Calendar.find_by(id: id + 1).day.month if !Calendar.find_by(id: id + 1).nil?
  end
end
