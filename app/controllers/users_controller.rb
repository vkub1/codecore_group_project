class UsersController < ApplicationController
    before_action :authenticate_user!

    def new
        @user = User.new
    end

    def create 
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            redirect_to root_path, notice: 'Logged in'
        else
            render :new
        end
    end

    def admin
        # if current_user.is_admin
        #   @enrollment = Enrollment.find params[:id] 
        #     redirect_to admin_path, notice: ''
        # else
        #      redirect_to root_path, alert: 'Not Authorized'
        # end

    end   
    
    private

    def user_params
        params.require(:user).permit(
            :first_name,
            :last_name,
            :email,
            :password,
            :password_confirmation
        )
    end
    
end
