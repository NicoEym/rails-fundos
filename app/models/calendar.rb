class Calendar < ApplicationRecord
  validates :day, presence: true
  has_many :aums, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :applications, dependent: :destroy
  has_many :returns, dependent: :destroy
end
