class BookingsController < ApplicationController

    before_action :find_booking, only: [:edit, :update, :show, :destroy]
    before_action :find_course
    #before_action :authorize_user!

    def index
        @bookings = Booking.order(created_at: :desc)
        
    end

    def new
        @booking= Booking.new
    end

    def create
        @course = Course.find params[:course_id]
        @booking  = Booking.new(params.require(:review).permit(:rate,:body))
        @booking.product = Product.find params[:product_id]  
        @booking.user = current_user
        @admin = User.find_by(email: "admin@user.com")

        Notification.create(message: "#{@booking.user.first_name} has requested to book facility ##{@booking.facility_id} from #{@booking.start_time} to #{@booking.end_time}", accepted: false, sender_id: @booking.user.id, receiver_id: @admin.id, is_request: true, request_type: "booking", booking_id: @booking.id)
    end    

    def show
    end

    def destroy
        @booking.destroy
        @admin = User.find_by(email: "admin@user.com")
        if (params[:notif])
            @notification = Notification.find params[:nid]
            @notification.update(read: true)
            Notification.create(message: "Your request to book facility ##{@booking.facility_id} has been denied", accepted: false, sender_id: @admin.id, receiver_id: @booking.user.id, is_request: false)
            redirect_to user_notifications_path, notice: "Request denied"
        else
            Notification.create(message: "#{@booking.user.first_name} has cancelled their reservation for facility ##{@booking.facility_id}", accepted: false, sender_id: @booking.user.id, receiver_id: @admin.id, is_request: false)
            redirect_to facilities_path, alert: "Your booking is cancelled"
        end
    end    

    def edit
        
    end
    
    def update
        @booking.update(approved: true)
        @notification = Notification.find params[:nid]
        @notification.update(read: true)
        @admin = User.find_by(email: "admin@user.com")

        Notification.create(message: "Your request to book facility ##{@booking.facility_id} has been approved", accepted: true, sender_id: @admin.id, receiver_id: @booking.user.id, is_request: false)
        redirect_to user_notifications_path, notice: "Request approved"
    end


    private 

    def find_course
        @course = Course.find params[:course_id]
    end
    

    def find_booking
        @booking = Booking.find params[:id]
    end
    
    def booking_params
        params.require(:booking).permit(:facility_id, :course_id, :start_date , :start_time , :end_date , :end_time, :comment )
    end

    def authorize_user!
        redirect_to root_path, alert: "Not Authorized!" unless can?(:crud, @booking)
    end
end
