class CreateCharts < ActiveRecord::Migration[5.2]
  def change
    create_table :charts do |t|
      t.bigint "shop_id", null: false
      t.string "name", null: false
      t.string "description", null: false
      t.string "col_1_caption", null: false, :default => 'Col1'
      t.string "col_2_caption", null: false, :default => 'Col2'
      t.string "col_3_caption", null: false, :default => 'Col3'
      t.boolean "is_show_product_page", null: false, :default => false
      t.boolean "is_deleted", null: false, :default => false
      t.timestamps
    end
  end
end
