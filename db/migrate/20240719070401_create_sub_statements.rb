class CreateSubStatements < ActiveRecord::Migration[7.0]
  def change
    create_table :sub_statements do |t|
      t.references  :statement,                  null: false, foreign_key: true
      t.references  :card,                       null: false, foreign_key: true
      t.integer     :charge_sum,                 null: false, default: 0
      t.string      :balance_before,             default: "0.00"
      t.string      :balance_after,              default: "0.00"
      t.integer     :status,                     null: false, default: 0
      t.string      :error_text
      t.string      :comment

      t.timestamps
    end
  end
end
