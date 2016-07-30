class Instructor::LessonsController < ApplicationController
	before_action :authenticate_user!
	before_action :require_authorized_for_current_section, only: [:new, :create]

	def new
		if current_section.course.user != current_user
			return render text: 'Unauthoried', status: :unauthorized
		end
		@lesson = Lesson.new
	end

	def create
		@lesson = current_section.lessons.create(lesson_params)
		redirect_to instructor_course_path(current_section.course)
	end

	def update
		current_lesson.update_attributes(lesson_params)
		render text: 'Updated!'
	end

	private

	def require_authorized_for_current_lesson
		if current_lesson.section.course.user != current_user
			render text: 'Unauthorized!', status: :unauthorized
		end
	end

	def current_lesson
		@current_lesson ||= Lesson.find(params[:id])
	end

	def require_authorized_for_current_section
		if current_section.course.user != current_user
			return render text: 'Unauthoried', status: :unauthorized
		end
	end

	helper_method :current_section
	def current_section
    	@current_section ||= Section.find(params[:section_id])
  	end

	def lesson_params
		params.require(:lesson).permit(:title, :subtitle, :video, :row_order_position)
	end
end
