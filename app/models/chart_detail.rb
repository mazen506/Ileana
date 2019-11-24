class ChartDetail < ApplicationRecord
  belongs_to :chart
  has_many :chart_products, dependent: :destroy
  accepts_nested_attributes_for :chart_products, allow_destroy: true
end