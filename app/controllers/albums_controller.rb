class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:create, :new, :edit, :update, :destroy]
  before_filter :find_user
  before_filter :find_album, only: [:edit, :update, :destroy, :show]
  before_filter :add_breadcrumbs
  before_filter :ensure_proper_user, only: [:edit, :new, :create, :update, :destroy]

  # GET /albums
  # GET /albums.json
  def index
    @albums = current_user.albums.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    redirect_to album_pictures_path(params[:id])
  end

  # GET /albums/new
  def new
    @album = current_user.albums.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @album }
    end
  end

  # GET /albums/1/edit
  def edit
    add_breadcrumb "Editing Album"
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = current_user.albums.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render action: 'show', status: :created, location: @album }
      else
        format.html { render action: 'new' }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to album_pictures_path(@album), notice: 'Album was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end
  end

  def url_options
    { profile_name: params[:profile_name] }.merge(super)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def ensure_proper_user
      if current_user != @user
        flash[:error] = "You don't have permission to do that."
        redirect_to albums_path
      end
    end

    def add_breadcrumbs
      add_breadcrumb @user, profile_path(@user)
      add_breadcrumb "Albums", albums_path
    end

    def find_user
      @user = User.find_by_profile_name(params[:profile_name])
    end

    def find_album
      @album = current_user.albums.find(params[:id])
    end

    def set_album
      @album = Album.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:user_id, :title, :pictures, :current_user, :album, :profile_name, :user, :first_name, :last_name, :albums_thumbnail)
    end
end
