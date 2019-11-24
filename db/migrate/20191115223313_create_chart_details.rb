class CreateChartDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :chart_details do |t|
      t.bigint "chart_id", null: false
      t.string "row_name", null: false
      t.string "col1", null: false
      t.string "col2", null: false
      t.string "col3", null: false
      t.timestamps
    end
  end
end