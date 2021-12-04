class Professional < ApplicationRecord
    validates :nameAndSurname, presence: true
    validates :nameAndSurname, uniqueness: true
    has_many :appointments
end
