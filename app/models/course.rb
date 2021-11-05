class Course < ApplicationRecord
    has_many :enrollments, dependent: :destroy
    has_many :enrolled_users, through: :enrollments, source: :user

    has_many :bookings, dependent: :destroy
    has_many :facilities_booked, through: :bookings, source: :facility

    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
    # belongs_to :user
    validates :title, presence: true

    
    def tag_names
        self.tags.map(&:name).join(", ")
    end

    
    def tag_names=(rhs)
        self.tags = rhs.strip.split(/\s*,\s*/).map do |tag_name|
            Tag.find_or_initialize_by(name: tag_name)
        end
    end

    def teacher
        self.enrolled_users.where('is_teacher = true')[0]
    end
end
