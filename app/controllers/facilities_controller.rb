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

  # action is not complete but for now it's MVP
  def create
    @facility = Facility.new(params.require(:facility).permit(:full_address, :features))
    if @facility.save
      redirect_to facility_path(@facility)
    else

    end
  end

  def edit
    @facility = Facility.find params[:id]
  end

  def update
    @facility = Facility.find params[:id]
    if @facility.update(params.require(:facility).permit(:full_address, :features))
      redirect_to facility_path(@facility.id)
    else
      render :edit
    end
  end

end
