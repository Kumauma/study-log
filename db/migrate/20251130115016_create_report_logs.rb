class CreateReportLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :report_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.date :log_date

      t.timestamps
    end
  end
end
