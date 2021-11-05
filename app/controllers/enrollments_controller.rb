class EnrollmentsController < ApplicationController
  before_action :find_enrollment, only: [:update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:update, :destroy]


  def index
    @enrollments = Enrollment.order(created_at: :desc)
 
  end

  def create
    @course = Course.find params[:course_id]
    @enrollment = Enrollment.new(user_id: params[:user_id], course_id: params[:course_id])
    @enrollment.course = @course
    @enrollment.user = current_user

    if @enrollment.valid?
      @enrollment.save
      Notification.create
      flash[:alert] = "enrollment request has been sent!"
      redirect_to course_path(@course)
    end
  end

  def update
    # @enrollment = Enrollment.find.params[:id]
    @enrollment.update({approved: true})
    redirect_to courses_path
  end



  def destroy
    # @enrollment = Enrollment.find params[:id]
    @enrollment.course = @course
    @enrollment.destroy
    flash[:alert] = @enrollment.errors.full_messages
    redirect_to courses_path, alert: "Your course is cancelled"
  end


  private
  def find_enrollment
    @enrollment = Enrollment.find params[:id]
  end

  def authorize_user!
    redirect_to courses_path, alert: "Not Authorized!" unless can?(:crud, @enrollment)
  end


end
