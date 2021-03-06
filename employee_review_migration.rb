require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db.sqlite3'
)

class EmployeeReviewMigration < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.integer :salary
      t.string :email
      t.string :phone
      t.text :review
      t.boolean :satisfactory, default: true
      t.integer :department_id
      t.timestamps null: false
    end
    create_table :departments do |t|
      t.string :name
    end
  end
end

# EmployeeReviewMigration.migrate(:up)
