class EnrollmentsController < ApplicationController

  def index
    
  end

  def create
    @enrollment = Enrollment.new(course_id: params[:course_id])
    @enrollment.user = current_user
    @teacher = Enrollment.where("course_id == :course_id AND is_teacher == :bool", {course_id: params[:course_id], bool: true})
    if @enrollment.valid?
      @enrollment.save
      Notification.create(message: "#{@enrollment.user.first_name} requested to enroll in your course", accepted: false, sender_id: @enrollment.user.id, receiver_id: @teacher.id, is_request: true, request_type: "enrollment")
      redirect_to course_path(@enrollment.course)
    end
  end


end
