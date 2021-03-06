class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :project, foreign_key: true
      t.string :title
      t.integer :size
      t.date :completed_at

      t.timestamps
    end
  end
end
