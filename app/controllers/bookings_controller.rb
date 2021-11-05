class BookingsController < ApplicationController

    before_action :find_booking, only: [:edit, :update, :show, :destroy]
    before_action :find_course, except: [:index]  
    #before_action :authorize_user!

    def index
        teacher_enrollments = current_user.enrollments.where('is_teacher = true')
        @courses = []
        teacher_enrollments.each do |enrollment|
            @courses.push(Course.find(enrollment.course_id))
        end

    end

    def new
        @booking= Booking.new
    end

    def create
        @booking = Booking.new(booking_params)
        @booking.course_id = @course.id
        @admin = User.find_by(email: "admin@user.com")
         
        if @booking.save
            Notification.create(message: "#{current_user.first_name} has requested to book facility ##{@booking.facility_id} from #{@booking.start_time} to #{@booking.end_time}", accepted: false, sender_id: current_user.id, receiver_id: @admin.id, is_request: true, request_type: "booking", booking_id: @booking.id)
            redirect_to course_bookings_path(@course.id), notice: 'Booking created!'
        else
            render :new
        end

    end    

    def show
    end

    def destroy
        @booking.destroy
        @admin = User.find_by(email: "admin@user.com")
        if (params[:notif])
            @notification = Notification.find params[:nid]
            @notification.update(read: true)
            Notification.create(message: "Your request to book facility ##{@booking.facility_id} has been denied", accepted: false, sender_id: @notification.receiver_id, receiver_id: @notification.sender_id, is_request: false)
            redirect_to user_notifications_path(@notification.receiver), notice: "You have denied #{@notification.sender.full_name}'s request to book a facility"
        else
            Notification.create(message: "#{current_user.first_name} has cancelled their reservation for facility ##{@booking.facility_id}", accepted: false, sender_id: current_user.id, receiver_id: @admin.id, is_request: false)
            redirect_to facilities_path, alert: "Your booking is cancelled"
        end
        #byebug
        #@booking = Answer.find params[:id]
       # if can?(:crud, @booking)
            # @booking.destroy
            #byebug
            # redirect_to course_bookings_path(@course.id),  notice: 'Answer Deleted'
      #  else
       #     redirect_to root_path, alert: 'Not Authorized'
      # end
    end    

    def edit
        
    end
    
    def update
        if (params[:notif])
            @booking.update(approved: true)
            @notification = Notification.find params[:nid]
            @notification.update(read: true)
            Notification.create(message: "Your request to book facility ##{@booking.facility_id} has been approved", accepted: true, sender_id: @notification.receiver_id, receiver_id: @notification.sender_id, is_request: false)
            redirect_to user_notifications_path(@notification.receiver), notice: "You have approved #{@notification.sender.full_name}'s' request to book a facility"     
        elsif @booking.update(booking_params)
            redirect_to course_bookings_path(@course.id), notice: 'Booking created!'
        else
            render :edit
        end
    end


    private 

    def find_course
        @course = Course.find params[:course_id]
    end
    

    def find_booking
        @booking = Booking.find params[:id]
    end
    
    def booking_params

        #byebug
        params.require(:booking).permit(:facility_id, :comment, :start_time, :end_time) 
    end

    def authorize_user!
        redirect_to root_path, alert: "Not Authorized!" unless can?(:crud, @booking)
    end
end
