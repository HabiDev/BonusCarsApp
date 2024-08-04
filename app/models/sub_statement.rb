class SubStatement < ApplicationRecord

  enum status: { registred: 0, success: 1, unsuccess: 2, executed: 3, delayed: 4, canceled: 5 }

  belongs_to :statement
  belongs_to :card

  validates :statement_id, :card_id, :charge_sum, presence: true
  validates :charge_sum, numericality: { greater_than: 0 }

  default_scope { joins(:card).order(owner_card: :asc, status: :asc) }

  def self.ransackable_attributes(auth_object = nil)
    ["card_id", "statement_id", "balance_before", "balance_after", "charge_sum", 
      "id", "create_at", "status", "error_text", "updated_at", "comment"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["statement"]
  end

  def self.import(file, parrent)
    accessible_attributes = ['statement_id', 'card_id','charge_sum']
    spreadsheet = open_spreadsheet(file)
    header = ['statement_id', 'card_id','charge_sum']
    (2..spreadsheet.last_row).each do |i|
      card = Card.find_by(code_card: spreadsheet.cell(i, 1))
      next unless card.present?
      sum = spreadsheet.cell(i, 2).round unless spreadsheet.cell(i, 2).nil?
      data = [parrent.to_i, card.id, sum]
      row = Hash[[header, data].transpose]
      sub_statement = new
      sub_statement.attributes = row.to_hash.slice(*accessible_attributes)
      sub_statement.save
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




