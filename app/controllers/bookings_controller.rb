class BookingsController < ApplicationController

    before_action :find_booking, only: [:edit, :update, :show, :destroy]
    before_action :find_course
    #before_action :authorize_user!

    def index
        enrollments = current_user.enrollments.where('is_teacher = true')
        @courses = []
        enrollments.each do |enrollment|
            @courses.push(Course.find enrollment.course_id)
        end
        @courses
    end

    def new
        @booking= Booking.new
    end

    def create

        @course = Course.find params[:course_id]
        @booking  = Bookings.new(params.require(:review).permit(:rate,:body))
        @booking.product = Product.find params[:product_id]  
        @booking.user = current_user

    end    

    def show
    end

    def destroy
    end    

    def edit
        
    end
    
    def update       
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
