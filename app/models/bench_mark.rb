class BenchMark < ApplicationRecord
  validates :name, presence: true
  has_many :funds
end
