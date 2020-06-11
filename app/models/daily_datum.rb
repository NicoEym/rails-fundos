class DailyDatum < ApplicationRecord
  belongs_to :fund
  belongs_to :calendar

end
