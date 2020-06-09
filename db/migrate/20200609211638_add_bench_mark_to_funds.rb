class AddBenchMarkToFunds < ActiveRecord::Migration[5.2]
  def change
    add_reference :funds, :bench_mark, foreign_key: true
  end
end
