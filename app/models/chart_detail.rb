class ChartDetail < ApplicationRecord
  
  belongs_to :chart
  validates :row_name, presence: true
  validates :col1, presence: true
  validates :col2, presence: true
  validates :col3, presence: true

end