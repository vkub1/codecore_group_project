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
    @teacher = Enrollment.where("course_id == :course_id AND is_teacher == :bool", {course_id: params[:course_id], bool: true})
    byebug
    if @enrollment.valid?
      @enrollment.save
      Notification.create(message: "#{@enrollment.user.first_name} requested to enroll in your course", accepted: false, sender_id: @enrollment.user.id, receiver_id: @teacher.id, is_request: true, request_type: "enrollment")
      flash[:alert] = "enrollment request has been sent!"
      redirect_to course_path(@course)
    end
  end

  def update
    n = Notification.find params[:id]
    Notification.create(message: "Your request to enroll in #{@enrollment.course_id.title} has been accepted", accepted: true, sender_id: @teacher.id, receiver_id: @enrollment.user.id, is_request: false)
    Notification.update(message: "Your request to enroll in #{@enrollment.course_id.title} has been accepted", accepted: true, sender_id: @teacher.id, receiver_id: @enrollment.user.id, is_request: false)
  end

  def destroy
    
    @enrollment = Enrollment.find.params[:id]
    Notification.create(message: "Your request to enroll in #{@enrollment.course_id.title} has been declined", accepted: true, sender_id: @teacher.id, receiver_id: @enrollment.user.id, is_request: false)
  end

end
