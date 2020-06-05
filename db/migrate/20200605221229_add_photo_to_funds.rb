class AddPhotoToFunds < ActiveRecord::Migration[5.2]
  def change
    add_column :funds, :photo_url, :string
  end
end
