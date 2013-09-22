class HackVenuesController < ApplicationController
  before_action :set_hack_venue, only: [:show, :edit, :update, :destroy]

  # GET /hack_venues
  # GET /hack_venues.json
  def index
    @hack_venues = HackVenue.all
  end

  # GET /hack_venues/1
  # GET /hack_venues/1.json
  def show
  end

  # GET /hack_venues/new
  def new
    @hack_venue = HackVenue.new
  end

  # GET /hack_venues/1/edit
  def edit
  end

  # POST /hack_venues
  # POST /hack_venues.json
  def create
    @hack_venue = HackVenue.new(hack_venue_params)

    respond_to do |format|
      if @hack_venue.save
        format.html { redirect_to @hack_venue, notice: 'Hack venue was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hack_venue }
      else
        format.html { render action: 'new' }
        format.json { render json: @hack_venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hack_venues/1
  # PATCH/PUT /hack_venues/1.json
  def update
    respond_to do |format|
      if @hack_venue.update(hack_venue_params)
        format.html { redirect_to @hack_venue, notice: 'Hack venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hack_venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hack_venues/1
  # DELETE /hack_venues/1.json
  def destroy
    @hack_venue.destroy
    respond_to do |format|
      format.html { redirect_to hack_venues_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hack_venue
      @hack_venue = HackVenue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hack_venue_params
      params.require(:hack_venue).permit(:venue, :notes)
    end
end
