class DailyDatum < ApplicationRecord
  belongs_to :fund
  belongs_to :calendar

  def last_common_day
    last_dates = Calendar.last(5).reverse
    last_dates.each do |last_date|
      number_of_fund_for_date = DailyDatum.where(calendar_id: last_date.id).count
      puts number_of_fund_for_date
      number_of_funds = Fund.count
      puts number_of_funds
      return date = last_date if number_of_fund_for_date == 17
    end
  end
end
