class Tag < ApplicationRecord
    before_save :downcase_name
    
    has_many :taggings, dependent: :destroy
    has_many :courses, through: :taggings
    has_many :facilities, through: :taggings

   

    validates :name, presence: true

    private

    def downcase_name
        self.name&.downcase!
    end
end
