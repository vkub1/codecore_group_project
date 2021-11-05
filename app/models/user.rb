class User < ApplicationRecord
    has_secure_password

    has_many :sent_notifications, class_name: "Notification", foreign_key: "sender_id", dependent: :destroy
    has_many :received_notifications, class_name: "Notification", foreign_key: "receiver_id", dependent: :destroy
    has_many :enrollments, dependent: :destroy
    has_many :enrolled_courses, through: :enrollments, source: :course


    validates :first_name, :last_name, presence:true
    validates :email, presence:true, uniqueness:true ,format: { with: /(\A([a-z]*\s*)*\<*([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\>*\Z)/i }
    validates :password, presence: true, length: { minimum: 3 }

    #returns all enrollments taught by this user
    def taught_courses 
        return User.enrollments.where("is_teacher = ? AND user_id = ?", true, self.id)
    end

    def full_name
        "#{first_name} #{last_name}"
    end


end
