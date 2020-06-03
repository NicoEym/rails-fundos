class AddCompetitorGroupToFunds < ActiveRecord::Migration[5.2]
  def change
    add_column :funds, :competitor_group, :string
  end
end
