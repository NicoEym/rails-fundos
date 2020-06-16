class BenchMark < ApplicationRecord
  validates :name, presence: true
  has_many :funds
  has_many :data_benchmarks
end
