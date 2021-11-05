class NotificationsController < ApplicationController

  def index
    @user = User.find params[:user_id]
    @notifications = @user.received_notifications
  end

  def update
    @notification = Notification.find params[:id]
    @notification.update(read: true)
    redirect_to user_notifications_path(current_user)
  end
  
end
