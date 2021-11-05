class BookingsController < ApplicationController

    before_action :find_booking, only: [:edit, :update, :show, :destroy]
    before_action :find_course
    #before_action :authorize_user!

    def index
        #@bookings = Booking.order(created_at: :desc)
         
        @bookings = Booking.where(:course_id=>@course.id) 
        #byebug
    end

    def new
        @booking= Booking.new
    end

    def create
  
        #@booking  = Booking.new(params.require(:booking).permit(:facility_id, :comment , :start_time, :end_time))
        @booking  = Booking.new(booking_params)
        @booking.course_id = @course.id
         
        if @booking.save
            
            #AnswerMailer.new_answer(@answer).deliver_now
            #Or try this   AnswerMailer.new_answer(@answer).deliver_later
            #AnswerMailer.delay(run_at:  1.minutes.from_now).new_answer(@answer)
            redirect_to course_bookings_path(@course.id), notice: 'Booking created!'
        else
           
            render :new
           
        end

    end    

    def show
    end

    def destroy
        #byebug
        #@booking = Answer.find params[:id]
       # if can?(:crud, @booking)
            @booking.destroy
            #byebug
            redirect_to course_bookings_path(@course.id),  notice: 'Answer Deleted'
      #  else
       #     redirect_to root_path, alert: 'Not Authorized'
      # end
    end    

    def edit
        
    end
    
    def update      

        if @booking.update(booking_params)
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
        params.require(:booking).permit(:facility_id, :comment , :start_time, :end_time) 
    end

    def authorize_user!
        redirect_to root_path, alert: "Not Authorized!" unless can?(:crud, @booking)
    end
end
