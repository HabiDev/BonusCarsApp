class CreateStatements < ActiveRecord::Migration[7.0]
  def change
    create_table :statements do |t|
      t.string     :item,             null: false, default: "0"
      t.references :division,         null: false, foreign_key: true
      t.decimal    :ammount,          null: false, default: 0, precision: 10, scale: 2
      t.integer    :status,           null: false, default: 0            
      t.string     :comment

      t.timestamps
    end
  end
end
