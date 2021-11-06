class FacilitiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def filter
    if params[:tag]
      @tag = Tag.find_or_initialize_by(name: params[:tag])
      @facilities = @tag.facilities.order('updated_at DESC')
      @taggings = Tagging.where('facility_id IS NOT NULL')
    else
      @facilities = Facility.all.order(created_at: :DESC)
      @taggings = Tagging.where('facility_id IS NOT NULL')
    end
  end

  def index
    if params[:tag]
      @tag = Tag.find_or_initialize_by(name: params[:tag])
      @tag = Tag.find_or_initialize_by(name: params[:tag])
      @facilities = @tag.facilities.order('updated_at DESC')
      @taggings = Tagging.where('facility_id IS NOT NULL')
    else
      @facilities = Facility.all.order(created_at: :DESC)
      @taggings = Tagging.where('facility_id IS NOT NULL')
    end
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
      if @facility.update(facility_params)
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
        redirect_to root_path, alert: "There was a problem deleting this facility!"
      end
    else
      redirect_to root_path, alert: "Only an Admin may delete a facility!"
    end
    
  end

  private 

  def facility_params
    params.require(:facility).permit(:full_address, :features, :tag_names)
  end
end
