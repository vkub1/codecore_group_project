class EnrollmentsController < ApplicationController

  def index
    
  end

  def create
    @enrollment = Enrollment.new(params.require(:enrollment).permit(:use_id, :course_id))
    @enrollment.course = @course
    @enrollment.user = current_user

    if @enrollment.valid?
      @enrollment.save
      Notification.create
      redirect_to course_path(@course)
    end
  end


end
