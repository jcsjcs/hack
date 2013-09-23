class HackMeetsController < ApplicationController
  before_action :set_hack_meet, only: [:show, :edit, :update, :destroy,
                                       :attendance, :update_attendance]

  # GET /hack_meets
  # GET /hack_meets.json
  def index
    @hack_meets = HackMeet.order('hack_year DESC, hack_month DESC').all
  end

  # GET /hack_meets/1
  # GET /hack_meets/1.json
  def show
  end

  # GET /hack_meets/new
  def new
    @hack_meet = HackMeet.new
  end

  # GET /hack_meets/1/edit
  def edit
  end

  # POST /hack_meets
  # POST /hack_meets.json
  def create
    @hack_meet = HackMeet.new(hack_meet_params)

    respond_to do |format|
      if @hack_meet.save
        format.html { redirect_to hack_meets_url, notice: 'Hack meet was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hack_meet }
      else
        format.html { render action: 'new' }
        format.json { render json: @hack_meet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hack_meets/1
  # PATCH/PUT /hack_meets/1.json
  def update
    respond_to do |format|
      if @hack_meet.update(hack_meet_params)
        format.html { redirect_to @hack_meet, notice: 'Hack meet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hack_meet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hack_meets/1
  # DELETE /hack_meets/1.json
  def destroy
    @hack_meet.destroy
    respond_to do |format|
      format.html { redirect_to hack_meets_url }
      format.json { head :no_content }
    end
  end

  def attendance
    @attended = @hack_meet.hack_attendances.all.map{|a| a.hack_member_id}
    @hack_members = HackMember.hack_seq
  end

  def update_attendance
    member_ids = params[:attendance_ids]
    # Remove all attendances for this hack
    # Then add all checked members
    @hack_meet.hack_attendances.destroy_all
    member_ids.each do |id|
      mem = HackMember.find(id)
      @hack_meet.hack_attendances.create(:hack_member => mem)
    end
    respond_to do |format|
      format.html { redirect_to(attendance_hack_meet_url(@hack_meet)) }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hack_meet
      @hack_meet = HackMeet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hack_meet_params
      params.require(:hack_meet).permit(:hack_year, :hack_month, :hack_date, :start_time, :work_area, :notes, :hack_venue_id, :social, :hack_attendances_count, :plant_type_ids => [])
    end
end
