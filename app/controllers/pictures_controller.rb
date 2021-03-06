require 'securerandom'

class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token

  # GET /pictures
  # GET /pictures.json
  def index
    Picture.where(created_at: (Time.new(0)..(Time.now - 30.minutes))).delete_all
    @pictures = Picture.all.reverse_order
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
  end

  # GET /pictures/new
  def new
    @picture = Picture.new
  end

  # GET /pictures/1/edit
  def edit
  end

  def raw
    if params[:id].to_i == 0
      send_data(File.read Rails.root.join('app', 'assets', 'images', 'jackass.jpg'))
    else
      pic = Picture.find params[:id]
      if pic
        send_data pic.data
      else
        # pic does not exist or is no longer viewable.
        nil
      end
    end
  end

  def snap

  end

  def create
    @picture = Picture.create(uid: SecureRandom.urlsafe_base64,
                              data: params[:picture].read)

    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
        format.json { render :show, status: :created, location: @picture }
      else
        format.html { render :new }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /pictures
  # POST /pictures.json
  def insert
    data = params[:datab64]
    image_data = Base64.decode64(data['data:image/jpeg;base64,'.length .. -1])
    @picture = Picture.create(uid: SecureRandom.urlsafe_base64,
                              data: image_data)

    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
        format.json { render :show, status: :created, location: @picture }
      else
        format.html { render :new }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: 'Picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_picture
    @picture = Picture.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def picture_params
    params.require(:picture).permit(:uid, :datab64)
  end
end
