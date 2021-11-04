class FacilitiesController < ApplicationController
  def index
    @facilities = Facility.all.order(created_at: :DESC)
  end

  def show
    @facility = Facility.find params[:id]
  end

  def new
    @facility = Facility.new
  end

  def create
    @facility = Facility.new(params.require(:facility).permit(:full_address, :features))
    if @facility.save
      redirect_to facility_path(@facility)
    else

    end
  end

end
