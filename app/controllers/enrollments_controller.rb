class EnrollmentsController < ApplicationController
  before_action :find_enrollment, only: [:update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:update, :destroy]


  def index
    @enrollments = current_user.enrollments.order(created_at: :desc)
 
  end

  def create
    @course = Course.find params[:course_id]
    @enrollment = Enrollment.new(user_id: params[:user_id], course_id: params[:course_id])
    @enrollment.course = @course
    @enrollment.user = current_user
    @teacher = Enrollment.where("is_teacher = ? AND course_id = ?", true, @course.id)[0]
    if @enrollment.valid?
      @enrollment.save
      Notification.create(message: "#{@enrollment.user.first_name} has requested to enroll in your #{@course.title} course", accepted: false, sender_id: @enrollment.user.id, receiver_id: @teacher.user_id, is_request: true, request_type: "enrollment", enrollment_id: @enrollment.id)
      flash[:notice] = "Enrollment request has been sent!"
      redirect_to course_path(@course)
    end
  end

  def update
    @enrollment.update(approved: true)
    @course = Course.find @enrollment.course_id
    @teacher = Enrollment.where("is_teacher = ? AND course_id = ?", true, @course.id)[0]
    @notification = Notification.find params[:nid]
    @notification.update(read: true)
    Notification.create(message: "Your request to enroll in #{@course.title} has been approved", accepted: true, sender_id: @teacher.user_id, receiver_id: @enrollment.user.id, is_request: false)
    redirect_to user_notifications_path(@notification.receiver), notice: "You have approved #{User.find(@notification.sender_id).full_name}'s request to enroll in the #{@course.title} course"
    # redirect_to courses_path
  end



  def destroy
    # @enrollment = Enrollment.find params[:id]
    @enrollment.destroy
    @course = Course.find @enrollment.course_id
    @teacher = Enrollment.where("is_teacher = ? AND course_id = ?", true, @course.id)[0]
    if (params[:notif])
      @notification = Notification.find params[:nid]
      @notification.update(read: true)
      Notification.create(message: "Your request to enroll in #{@course.title} has been declined", accepted: false, sender_id: @teacher.user_id, receiver_id: @enrollment.user.id, is_request: false)
      redirect_to user_notifications_path(@notification.receiver), notice: "You have denied #{User.find(@notification.sender_id).full_name}'s request to enroll in the #{@course.title} course"
    else
      Notification.create(message: "#{@enrollment.user.first_name} has cancelled their enrollment for your #{@course.title} course", accepted: false, sender_id: @enrollment.user.id, receiver_id: @teacher.user_id, is_request: false)
      flash[:alert] = @enrollment.errors.full_messages
      redirect_to courses_path, notice: "Your have cancelled your enrollment"
    end
  end


  private
  def find_enrollment
    @enrollment = Enrollment.find params[:id]
  end

  def authorize_user!
    redirect_to courses_path, alert: "Not Authorized!" unless can?(:crud, @enrollment)
  end


end
