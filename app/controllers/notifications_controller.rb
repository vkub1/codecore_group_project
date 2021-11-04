class NotificationsController < ApplicationController

  def index
    @user = User.find params[:user_id]
    @notifications = @user.received_notifications
  end
end
