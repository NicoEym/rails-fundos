class AnbimaClass < ApplicationRecord
  validates :name, presence: true
  has_many :funds
end
