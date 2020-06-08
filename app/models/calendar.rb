class Calendar < ApplicationRecord
  validates :day, presence: true
  has_many :daily_data, dependent: :destroy
end
