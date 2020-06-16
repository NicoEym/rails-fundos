class AddCodigoToBenchMarks < ActiveRecord::Migration[5.2]
  def change
    add_column :bench_marks, :codigo_economatica, :string
  end
end
