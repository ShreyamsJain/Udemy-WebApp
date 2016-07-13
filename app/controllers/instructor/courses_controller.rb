class Instructor::CoursesController < ApplicationController
	before_action :authenticate_user!
	def new
		@course = Course.new
	end

	def create
		@course = current_user.courses.create(course_params)
		if @course.valid?
			redirect_to instructor_course_path(@course)
		else
			render :new, status: :unprocessable_entity
		end
	end

	def show
		@course = Course.find(params[:id])
	end

	def destroy
		@course = Course.find(params[:id])
		@course.destroy
		redirect_to root_path
	end

	private

	def course_params
		params.require(:course).permit(:title, :description, :cost)
	end
end