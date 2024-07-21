class Card < ApplicationRecord

  has_many :sub_statement, dependent: :destroy

  validates :owner_card, :code_card, :release_at, presence: true

  default_scope { order(owner_card: :asc, release_at: :asc) }


  def self.ransackable_attributes(auth_object = nil)
    ["balance", "code_card", "created_at", "default_charge_sum", "id", "locked_at", "owner_card", "release_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["sub_statements"]
  end
end
