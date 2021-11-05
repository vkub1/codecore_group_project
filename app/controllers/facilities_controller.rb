class FacilitiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

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
    @facility = Facility.new(facility_params)
    # @facility.user = current_user
    if current_user&.is_admin?
      if @facility.save
        redirect_to facility_path(@facility)
      else
        render :new
      end
    else
      redirect_to root_path, alert: "Only an Admin may add a new facility!"
    end
    
  end

  def edit
    @facility = Facility.find params[:id]
  end

  def update
    @facility = Facility.find params[:id]
    if current_user&.is_admin?
      if @facility.update(params.require(:facility).permit(:full_address, :features))
        redirect_to facility_path(@facility.id)
      else
        render :edit
      end
    else
      redirect_to root_path, alert: "Only an Admin may make updates!"
    end
  end

  def destroy
    @facility = Facility.find params[:id]
    if current_user&.is_admin?
      if @facility.destroy
        redirect_to facilities_path
      else
        redirect_to root_path, alert: "Only an Admin may remove a facility!"
      end
    else
      redirect_to root_path, alert: "Only an Admin may remove a facility!"
    end
    
  end

  private 

  def facility_params
    params.require(:facility).permit(:full_address, :features, tag_ids:[])
  end
end
