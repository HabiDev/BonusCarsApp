class Card < ApplicationRecord

  has_many :sub_statement, dependent: :destroy

  validates :owner_card, :code_card, :release_at, presence: true

  default_scope { order(owner_card: :asc, release_at: :asc) }

  scope :active, -> { where(locked_at: nil) }


  def self.ransackable_attributes(auth_object = nil)
    ["balance", "code_card", "created_at", "default_charge_sum", "id", "locked_at", "owner_card", "release_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["sub_statements"]
  end

  def self.import(file)
    accessible_attributes = ['owner_card','code_card', 'release_at', 'default_charge_sum']
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      card = find_by_id(row["id"]) || new
      card.attributes = row.to_hash.slice(*accessible_attributes)
      card.save
    end
  end
  
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
