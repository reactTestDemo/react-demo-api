class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Set DoorKeeper for Devise
  devise :doorkeeper

  # Add roles to User
  rolify

  # Relations
  has_many :applications, -> (object) {where(oauth_applications: { owner_type: 'User' })},
           class_name: 'Doorkeeper::Application', foreign_key: 'owner_id'

  def admin?
    roles.pluck(:name).include?('admin')
  end

end
