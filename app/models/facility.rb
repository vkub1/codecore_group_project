class Facility < ApplicationRecord
    has_many :bookings, dependent: :destroy
    has_many :booked_courses, through: :bookings, source: :course
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings

    
    validates :full_address, presence: { message: "must be provided" }, uniqueness: true
    validates :features, presence: true
    
    def tag_names
        self.tags.map(&:name).join(", ")
    end

    
    def tag_names=(rhs)
        self.tags = rhs.strip.split(/\s*,\s*/).map do |tag_name|
            Tag.find_or_initialize_by(name: tag_name)
        end
    end

   

end
