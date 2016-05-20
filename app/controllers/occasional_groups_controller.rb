class OccasionalGroupsController < ApplicationController
  before_action :set_hack_meet
  before_action :set_occasional_group, only: [:show, :edit, :update, :destroy]

  # GET /occasional_groups
  # GET /occasional_groups.json
  def index
    @occasional_groups = OccasionalGroup.all
  end

  # GET /occasional_groups/1
  # GET /occasional_groups/1.json
  def show
  end

  # GET /occasional_groups/new
  def new
    @occasional_group = OccasionalGroup.new
  end

  # GET /occasional_groups/1/edit
  def edit
  end

  # POST /occasional_groups
  # POST /occasional_groups.json
  def create
    @occasional_group = OccasionalGroup.new(occasional_group_params)

    respond_to do |format|
      if @hack_meet.occasional_groups << @occasional_group
        format.html { redirect_to @hack_meet, notice: 'Occasional group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @occasional_group }
      else
        format.html { render action: 'new' }
        format.json { render json: @occasional_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /occasional_groups/1
  # PATCH/PUT /occasional_groups/1.json
  def update
    respond_to do |format|
      if @occasional_group.update(occasional_group_params)
        format.html { redirect_to @hack_meet, notice: 'Occasional group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @occasional_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /occasional_groups/1
  # DELETE /occasional_groups/1.json
  def destroy
    @occasional_group.destroy
    respond_to do |format|
      format.html { redirect_to @hack_meet, notice: 'Occasional group was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_occasional_group
      @occasional_group = OccasionalGroup.find(params[:id])
    end

    def set_hack_meet
      @hack_meet = HackMeet.find(params[:hack_meet_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def occasional_group_params
      params.require(:occasional_group).permit(:description, :no_of_attendees, :notes, :references)
    end
end
