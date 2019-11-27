class ChangeChartDefaultValues < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:charts, :col_1_caption, 'Col1')
    change_column_default(:charts, :col_2_caption, 'Col2')
    change_column_default(:charts, :col_3_caption, 'Col3')
  end
end
