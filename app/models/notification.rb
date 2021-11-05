class Notification < ApplicationRecord
    belongs_to :sender, class_name: "User"
    belongs_to :receiver, class_name: "User"

    validates :message, presence: true

    def sender
        if self.sender_id
            @user = User.find self.sender_id
        end
        @user
    end

    def receiver
        if self.receiver_id
            @user = User.find self.receiver_id
        end
        @user
    end

    def booking
        if self.booking_id
            @booking = Booking.find self.booking_id
        end
        @booking
    end
end
