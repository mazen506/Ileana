class CreateChartProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :chart_products do |t|
      t.integer "chart_id", null: false
      t.string "product_id", null: false
      t.timestamps
    end
  end
end
