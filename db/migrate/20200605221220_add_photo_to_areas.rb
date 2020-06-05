class AddPhotoToAreas < ActiveRecord::Migration[5.2]
  def change
    add_column :areas, :photo_url, :string
  end
end
