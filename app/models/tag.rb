class Tag < ApplicationRecord
    has_many :taggings, dependent: :destroy
    has_many :courses, through: :taggings
    has_many :facilities, through: :taggings
end
