class Facility < ApplicationRecord
    has_many :bookings, dependent: :destroy
    has_many :booked_courses, through: :bookings, source: :course
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
end
