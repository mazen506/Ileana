class Chart < ApplicationRecord
      validates :name, presence: true,
                length: { minimum: 5 }
      validate :at_least_one_product

      belongs_to :shop
      has_many :chart_details, dependent: :destroy
      has_many :chart_products, dependent: :destroy
      accepts_nested_attributes_for :chart_details, allow_destroy: true
      accepts_nested_attributes_for :chart_products, allow_destroy: true

      validates_associated :chart_details
      validates_associated :chart_products

      private
      def at_least_one_product
        # when creating a new chart: making sure at least one product exists
        return errors.add :base, "Must have at least one Product" unless chart_products.length > 0
    
      end  

end