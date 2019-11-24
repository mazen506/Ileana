class ChartProduct < ApplicationRecord
  belongs_to :chart_detail
  has_many :chart_products, dependent: :destroy
  accepts_nested_attributes_for :chart_products, allow_destroy: true
end
