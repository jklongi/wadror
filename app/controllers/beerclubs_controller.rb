class BeerclubsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :ensure_that_signed_in_as_admin, only: [:destroy]
  before_action :set_beer_club, only: [:show, :edit, :update, :destroy]

  # GET /beer_clubs
  # GET /beer_clubs.json
  def index
    @beerclubs = Beerclub.all
  end

  # GET /beer_clubs/1
  # GET /beer_clubs/1.json
  def show
    @membership = Membership.new
    @membership.beerclub = @beerclub
  end

  # GET /beer_clubs/new
  def new
    @beer_club = Beerclub.new
  end

  # GET /beer_clubs/1/edit
  def edit
  end

  # POST /beer_clubs
  # POST /beer_clubs.json
  def create
    @beer_club = Beerclub.new(beerclub_params)

    respond_to do |format|
      if @beerclub.save
        format.html { redirect_to @beerclub, notice: 'Beer club was successfully created.' }
        format.json { render action: 'show', status: :created, location: @beerclub }
      else
        format.html { render action: 'new' }
        format.json { render json: @beerclub.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beer_clubs/1
  # PATCH/PUT /beer_clubs/1.json
  def update
    respond_to do |format|
      if @beer_club.update(beerclub_params)
        format.html { redirect_to @beerclub, notice: 'Beer club was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @beerclub.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beer_clubs/1
  # DELETE /beer_clubs/1.json
  def destroy
    @beerclub.destroy
    respond_to do |format|
      format.html { redirect_to beerclubs_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_beer_club
    @beerclub = Beerclub.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def beer_club_params
    params.require(:beerclub).permit(:name, :founded, :city)
  end
end