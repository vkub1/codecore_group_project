class CoursesController < ApplicationController
    before_action :find_course, only: [:edit, :update, :show, :destroy]
    before_action :authenticate_user!, except: [:index, :show]
    before_action :authorize_user!, only: [:update, :destroy]

    def index
        if params[:tag]
            @tag = Tag.find_or_initialize_by(name: params[:tag])
            @courses = @tag.courses.order('updated_at DESC')
            @taggings = Tagging.where('course_id IS NOT NULL')
          else
            @courses = Course.all
            @taggings = Tagging.where('course_id IS NOT NULL')
          end
    end
    def show
        # if @course.bookings.where('end_time > ?', Time.now).count > 0
        #     flash[:alert] = "All of your course bookings have expired!"
        # end
        @enrollment = @course.enrollments.find_by(user: current_user)
        # byebug
    end
    def new
        @course=Course.new
    end
    def create
        @course = Course.new(course_params)
        # @course.user = current_user
        if @course.save
            Enrollment.create(user_id: current_user.id, course_id:@course.id, is_teacher: true, approved: true)
           # flash[:notice] = "course created successfully!"
            redirect_to course_path(@course.id)
        else
            render :new
        end
    end
    def edit

    end
    def update
        if @course.update(course_params)
            redirect_to course_path(@course.id)
        else
            render :edit
        end
    end

    def destroy
        @course.destroy
        redirect_to courses_path
    end





    def find_course
        @course =  Course.find(params[:id])
    end

    def course_params
        params.require(:course).permit(:title,:description,:max_students, :tag_names)
    end
     def authorize_user!
         redirect_to courses_path, alert: "Not Authorized!" unless can?(:crud, @course)
     end
end
