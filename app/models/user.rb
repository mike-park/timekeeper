class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :therapist

  scope :by_name, -> { order('name asc') }
end
