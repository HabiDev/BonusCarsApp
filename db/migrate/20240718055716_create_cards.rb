class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string    :owner_card,              null: false, default: ""
      t.string    :code_card,               null: false
      t.datetime  :release_at,              null: false
      t.integer   :default_charge_sum,      default: 0
      t.float     :balance,                 default: 0.00
      t.datetime  :locked_at

      t.timestamps
    end
      add_index :cards, :owner_card,               unique: true
      add_index :cards, :code_card,                unique: true
  end
end
