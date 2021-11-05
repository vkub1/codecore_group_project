class User < ApplicationRecord
    has_secure_password

    has_many :sent_notifications, class_name: "Notification", foreign_key: "sender_id", dependent: :destroy
    has_many :received_notifications, class_name: "Notification", foreign_key: "receiver_id", dependent: :destroy
    has_many :enrollments, dependent: :destroy
    has_many :enrolled_courses, through: :enrollments, source: :course


    #returns all enrollments taught by this user
    def taught_courses 
        return User.enrollments.where("is_teacher = ? AND user_id = ?", true, self.id)
    end
end
