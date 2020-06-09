class CreateBenchMarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bench_marks do |t|
      t.string :name

      t.timestamps
    end
  end
end
