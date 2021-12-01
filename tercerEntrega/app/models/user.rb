class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true
    validates :email, uniqueness: true
    validates :password, confirmation: true, length: { minimum: 8, maximum: 15 }
    validates :password_confirmation, presence: true
end
