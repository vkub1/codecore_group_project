class EnrollmentsController < ApplicationController

  def index
    @enrollments = Enrollment.order(created_at: :desc)
    @enrollment = Enrollment.find.params[:id]
    @enrollment.course = @course
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



  def destroy
    @enrollment = Enrollment.find params[:id]
    @enrollment.destroy
    flash[:alert] = @enrollment.errors.full_messages
    redirect_to courses_path, alert: "Your course is cancelled"
  end


end
