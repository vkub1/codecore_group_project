class Course < ApplicationRecord
    has_many :enrollments, dependent: :destroy
    has_many :enrolled_users, through: :enrollments, source: :user

    has_many :bookings, dependent: :destroy
    has_many :facilities_booked, through: :bookings, source: :facility

    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
    
    validates :title, presence: true
end
