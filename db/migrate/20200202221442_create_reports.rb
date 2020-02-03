class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :repo, null: false
      t.text :result
      t.integer :state, default: 0

      t.timestamps

    end

    add_index :reports, :repo, unique: true
  end
end
