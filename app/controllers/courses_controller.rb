class CoursesController < ApplicationController
    before_action :find_course, only: [:edit, :update, :show, :destroy]

    def index
        @courses=Course.all
    end
    def show
        @user = current_user
    end
    def new
        @course=Course.new
    end
    def create
        @course = Course.new(course_params)
        #@course.user = current_user
        if @course.save
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
        params.require(:course).permit(:title,:description,:max_students)
    end
end
