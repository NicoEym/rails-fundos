class Calendar < ApplicationRecord
  validates :day, presence: true
end
