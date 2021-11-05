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
    @teacher = Enrollment.where("course_id == :course_id AND is_teacher == :bool", {course_id: @course.id, bool: true})
    if @enrollment.valid?
      @enrollment.save
      Notification.create(message: "#{@enrollment.user.first_name} requested to enroll in your course", accepted: false, sender_id: @enrollment.user.id, receiver_id: @teacher.id, is_request: true, request_type: "enrollment", enrollment_id: @enrollment.id)
      flash[:alert] = "enrollment request has been sent!"
      redirect_to course_path(@course)
    end
  end

  def update
    @enrollment = Enrollment.find params[:id]
    @teacher = Enrollment.where("course_id == :course_id AND is_teacher == :bool", {course_id: @course.id, bool: true})
    @notification = params[:nid]
    @notification.update(read: true)
    Notification.create(message: "Your request to enroll in #{@enrollment.course_id.title} has been approved", accepted: true, sender_id: @teacher.id, receiver_id: @enrollment.user.id, is_request: false)
  end

  def destroy
    @enrollment = Enrollment.find params[:id]
    @teacher = Enrollment.where("course_id == :course_id AND is_teacher == :bool", {course_id: @course.id, bool: true})
    @notification = params[:nid]
    @notification.update(read: true)
    if (params[:notif])
      Notification.create(message: "Your request to enroll in #{@enrollment.course_id.title} has been declined", accepted: false, sender_id: @teacher.id, receiver_id: @enrollment.user.id, is_request: false)
    else
      Notification.create(message: "#{@enrollment.user.first_name} has cancelled their enrollment for your #{@enrollment.course_id.title} course", accepted: false, sender_id: @enrollment.user.id, receiver_id: @teacher.id, is_request: false)
    end
    @enrollment.destroy
    flash[:alert] = @enrollment.errors.full_messages
    redirect_to courses_path, alert: "Your course is cancelled"
end
