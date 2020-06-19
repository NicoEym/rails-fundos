class Fund < ApplicationRecord

  # include AlgoliaSearch

  # algoliasearch do
  #   attributes :name, :photo_url, :gestor, :area_name
  #   # Select the attributes you want to search in
  #   searchableAttributes ['name', 'gestor']

  #   # Set up some attributes to filter results on
  #   # attributesForFaceting "area_name"
  # end

  validates :codigo_economatica, presence: true
  validates :name, presence: true
  belongs_to :gestor
  has_one :area
  belongs_to :bench_mark
  belongs_to :anbima_class
  has_many :daily_data, dependent: :destroy

  #class method to get the shortest name between the name and the shortname of the fund if the short name exists
  def best_name
    if short_name.nil?
      best_name = name
    else
      best_name = short_name
    end
  end
end
