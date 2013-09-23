class HackMembersController < ApplicationController
  before_action :set_hack_member, only: [:show, :edit, :update, :destroy]

  # GET /hack_members
  # GET /hack_members.json
  def index
    @hack_members = []
    hack_members = []
    HackMember.all.each {|r| hack_members << r.to_grid_row }
    @grid_columns = HackMember.grid_columns.to_json
    @grid_data    = hack_members.to_json
    #logger.info ">>> #{@grid_columns}"
  end

  # GET /hack_members/1
  # GET /hack_members/1.json
  def show
    @hack_meets  = @hack_member.hack_meets
  end

  # GET /hack_members/new
  def new
    @hack_member = HackMember.new
  end

  # GET /hack_members/1/edit
  def edit
  end

  # POST /hack_members
  # POST /hack_members.json
  def create
    @hack_member = HackMember.new(hack_member_params)

    respond_to do |format|
      if @hack_member.save
        format.html { redirect_to @hack_member, notice: 'Hack member was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hack_member }
      else
        format.html { render action: 'new' }
        format.json { render json: @hack_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hack_members/1
  # PATCH/PUT /hack_members/1.json
  def update
    respond_to do |format|
      if @hack_member.update(hack_member_params)
        format.html { redirect_to @hack_member, notice: 'Hack member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hack_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hack_members/1
  # DELETE /hack_members/1.json
  def destroy
    @hack_member.destroy
    respond_to do |format|
      format.html { redirect_to hack_members_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hack_member
      @hack_member = HackMember.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hack_member_params
      params.require(:hack_member).permit(:title, :initials, :first_name, :surname, :tel_home, :tel_office, :tel_cell, :email, :email_ok, :email_issues, :non_hacker, :comments, :contact_via, :group_with, :hack_attendances_count)
    end
end
