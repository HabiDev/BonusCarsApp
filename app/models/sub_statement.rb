class SubStatement < ApplicationRecord

  enum status: { registred: 0, success: 1, unsuccess: 2 }

  belongs_to :statement
  belongs_to :card

  validates :statement_id, :card_id, :charge_sum, presence: true
  validates :charge_sum, numericality: { greater_than: 0 }

  default_scope { order(created_at: :desc, status: :asc) }

  def self.ransackable_attributes(auth_object = nil)
    ["card_id", "statement_id", "balance_before", "balance_after", "charge_sum", 
      "id", "create_at", "status", "error_text", "updated_at", "comment"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["statement"]
  end
end
