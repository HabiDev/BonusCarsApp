class User < ApplicationRecord 
  enum type_role: { user: 0, guide: 1, admin: 3, moderator: 4 }

   # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :rememberable, :validatable, :lockable, 
         :trackable, :timeoutable, :recoverable

  has_one :profile, dependent: :destroy
    
  accepts_nested_attributes_for :profile, allow_destroy: true

  # default_scope { joins(:profile).order(full_name: :asc) }

  def full_name
    self.profile.full_name
  end

  # def author_of?(resource)
  #   self.id == resource.author_id
  # end
  
  # def executor_of?(resource)
  #   self.id == resource.executor_id
  # end

  # def control_executor_of?(resource)
  #   self.id == resource.control_executor_id
  # end

  # def manager_of?(resource)
  #   self.id == resource.executor.manager_id
  # end
  
end
