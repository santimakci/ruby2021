class Appointment < ApplicationRecord
    validates :date, presence: true
    validates :user_id, presence: true
    validates :hour, presence: true
    validates :professional_id, presence: true
    belongs_to :user
    belongs_to :professional
end
