class Aum < ApplicationRecord
  belongs_to :fund
  belongs_to :calendar
  validates :value, presence: true
end
