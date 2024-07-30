class Statement < ApplicationRecord
  before_save :set_number_statement

  enum status: { registred: 0, 
                 success: 1, 
                 unsuccess: 2, 
                 executed: 3,
                 delayed: 4,
                 canceled: 5 }

  belongs_to :division, optional: true
  has_many :sub_statements, dependent: :destroy

  validates :division_id, :item, :status, :ammount, presence: true

  default_scope { order(created_at: :desc, status: :asc) }

  def self.ransackable_attributes(auth_object = nil)
    ["division_id", "item", "id", "created_at", "status", "ammount", 
      "comment", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["sub_statements", "division"]
  end

  private

  def set_number_statement
    if self.new_record?
      Statement.first.present? ? number = Statement.first.id + 1 : number = 1
      self.item = "#{number}/#{Date.today.year}" 
    end
  end
end
