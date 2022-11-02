class User < ApplicationRecord 
  enum type_role: { user: 0, guide: 1, admin: 3, moderator: 4 }
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :rememberable, :validatable, :lockable, 
         :trackable, :timeoutable

  has_one :profile, dependent: :destroy
  has_many :completed_tasks, dependent: :destroy

  accepts_nested_attributes_for :profile, allow_destroy: true

  # broadcasts_to ->(user) { "users" }, inserts_by: :prepend

end
