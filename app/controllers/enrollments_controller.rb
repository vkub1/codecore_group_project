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
    @teacher = Enrollment.where("is_teacher = ? AND course_id = ?", true, @course.id)[0]
    if @enrollment.valid?
      @enrollment.save
      Notification.create(message: "#{@enrollment.user.first_name} requested to enroll in your course", accepted: false, sender_id: @enrollment.user.id, receiver_id: @teacher.user_id, is_request: true, request_type: "enrollment", enrollment_id: @enrollment.id)
      flash[:alert] = "enrollment request has been sent!"
      redirect_to course_path(@course)
    end
  end

  def update
    @enrollment = Enrollment.find params[:id]
    @teacher = Enrollment.where("is_teacher = ? AND course_id = ?", true, @course.id)[0]
    @course = Course.find @enrollment.course_id
    @notification = params[:nid]
    @notification.update(read: true)
    Notification.create(message: "Your request to enroll in #{@course.title} has been approved", accepted: true, sender_id: @teacher.user_id, receiver_id: @enrollment.user.id, is_request: false)
  end

  def destroy
    @enrollment = Enrollment.find params[:id]
    @enrollment.destroy
    @teacher = Enrollment.where("is_teacher = ? AND course_id = ?", true, @enrollment.course.id)[0]
    @course = Course.find @enrollment.course_id
    if (params[:notif])
      @notification = Notification.find params[:nid]
      @notification.update(read: true)
      Notification.create(message: "Your request to enroll in #{@course.title} has been declined", accepted: false, sender_id: @teacher.user_id, receiver_id: @enrollment.user.id, is_request: false)
    else
      Notification.create(message: "#{@enrollment.user.first_name} has cancelled their enrollment for your #{@course.title} course", accepted: false, sender_id: @enrollment.user.id, receiver_id: @teacher.user_id, is_request: false)
      flash[:alert] = @enrollment.errors.full_messages
      redirect_to courses_path, alert: "Your course is cancelled"
    end
  end

end