class EnrollmentsController < ApplicationController

  def index
    @enrollments = Enrollment.order(created_at: :desc)
    @enrollments = Enrollment.find.params[:id]

    if @enrollment.approved 

    else
    end
  end

  def create
    @enrollment = Enrollment.new(params.require(:enrollment).permit(:user_id, :course_id))
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
