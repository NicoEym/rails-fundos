class Fund < ApplicationRecord
  validates :codigo_economatica, presence: true
  validates :name, presence: true
  validates :short_name, presence: true
  belongs_to :gestor
  belongs_to :area
  belongs_to :anbima_class
  has_many :aum
  has_many :share
end
