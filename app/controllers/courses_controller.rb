class CoursesController < ApplicationController
    before_action :find_course, only: [:edit, :update, :show, :destroy]
    before_action :authenticate_user!, except: [:index, :show]
    before_action :authorize_user!, only: [:update, :destroy]

    def index
        @courses=Course.all
    end
    def show
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
            Enrollment.create({user_id: current_user, course_id: @course, is_teacher: true, approved: true})
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
        params.require(:course).permit(:title,:description,:max_students, tag_ids:[])
    end
    def authorize_user!
        redirect_to courses_path, alert: "Not Authorized!" unless can?(:crud, @course)
    end
end
