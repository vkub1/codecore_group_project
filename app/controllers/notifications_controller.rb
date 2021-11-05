class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find params[:user_id]
    @notifications = @user.received_notifications.where("read = false").order(created_at: :desc)
  end

  def update
    @notification = Notification.find params[:id]
    @notification.update(read: true)
    redirect_to user_notifications_path(current_user)
  end
  
end
