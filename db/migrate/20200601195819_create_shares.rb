class CreateShares < ActiveRecord::Migration[5.2]
  def change
    create_table :shares do |t|
      t.float :value
      t.references :fund, foreign_key: true
      t.references :calendar, foreign_key: true

      t.timestamps
    end
  end
end
