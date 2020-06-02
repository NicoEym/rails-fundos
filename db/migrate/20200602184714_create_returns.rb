class CreateReturns < ActiveRecord::Migration[5.2]
  def change
    create_table :returns do |t|
      t.references :fund, foreign_key: true
      t.references :calendar, foreign_key: true
      t.float :daily_value
      t.float :weekly_value
      t.float :monthly_value
      t.float :quarterly_value
      t.float :yearly_value

      t.timestamps
    end
  end
end
