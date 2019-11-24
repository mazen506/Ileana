class Chart < ApplicationRecord
      validates :name, presence: true,
                length: { minimum: 5 }
      belongs_to :shop
      has_many :chart_details, dependent: :destroy
      has_many :chart_products, dependent: :destroy
      accepts_nested_attributes_for :chart_details, allow_destroy: true
      accepts_nested_attributes_for :chart_products, allow_destroy: true
end