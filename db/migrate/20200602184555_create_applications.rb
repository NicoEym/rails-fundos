class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.references :fund, foreign_key: true
      t.references :calendar, foreign_key: true
      t.float :weekly_net_value
      t.float :monthly_net_value
      t.float :quarterly_net_value
      t.float :yearly_net_value

      t.timestamps
    end
  end
end
