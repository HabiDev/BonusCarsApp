class AddStatementAtToStatements < ActiveRecord::Migration[7.0]
  def change
    add_column :statements, :statement_at, :datetime
  end
end
