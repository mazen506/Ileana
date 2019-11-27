class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products, id: :string do |t|
      t.timestamps
    end
  end
end
