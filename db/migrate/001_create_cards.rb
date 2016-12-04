class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :trello_id, null: false
      t.integer :card_type, null: false
      t.integer :redmine_id, null: false
      t.timestamps
    end

    change_table :cards do |t|
      t.index :trello_id, unique: true
    end
  end
end
