class Fund < ApplicationRecord
  validates :codigo_economatica, presence: true
  validates :name, presence: true
  belongs_to :gestor
  has_one :area
  belongs_to :anbima_class
  has_many :aums, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :applications, dependent: :destroy
  has_many :returns, dependent: :destroy
  has_many :indicators, dependent: :destroy
end
