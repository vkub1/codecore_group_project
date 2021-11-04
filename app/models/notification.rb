class Notification < ApplicationRecord
    belongs_to :sender, class_name: "User"
    belongs_to :receiver, class_name: "User"

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
end
