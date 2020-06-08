class Fund < ApplicationRecord
  validates :codigo_economatica, presence: true
  validates :name, presence: true
  belongs_to :gestor
  has_one :area
  belongs_to :anbima_class
  has_many :daily_data, dependent: :destroy
end
