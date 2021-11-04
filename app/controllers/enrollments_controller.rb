class EnrollmentsController < ApplicationController

  def index
    @enrollments = Enrollment.order(created_at: :desc)
    @enrollment = Enrollment.find.params[:id]
    @enrollment.course = @course
  end

  def create
    @enrollment = Enrollment.new(user_id: params[:user_id], course_id: params[:course_id])
    @enrollment.course = @course
    @enrollment.user = current_user

    if @enrollment.valid?
      @enrollment.save
      Notification.create
      redirect_to course_path(@course)
    end
  end

  def update
  
  end

  def destroy
    @enrollment = Enrollment.find.params[:id]

  end


end
