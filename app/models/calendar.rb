class Calendar < ApplicationRecord
  validates :day, presence: true
  has_many :aum
  has_many :share
end
