class CreateTodos < ActiveRecord::Migration[8.1]
  def change
    create_table :todos do |t|
      t.string :content, null: false
      t.boolean :complete, default: false, null: false
      t.datetime :start_time, default: -> { "CURRENT_TIMESTAMP" }, null: false

      t.timestamps
    end
  end
end
