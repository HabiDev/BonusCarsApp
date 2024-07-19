class Profile < ApplicationRecord
  belongs_to :user
  
  validates :full_name, :mobile, presence: true

  default_scope { order(full_name: :asc) }

end
