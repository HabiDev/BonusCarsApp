class Division < ApplicationRecord
  has_many :statement, dependent: :destroy

  validates :name, presence: true
  
end
