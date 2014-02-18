class StatusesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :update, :destroy] 
  before_action :set_status, only: [:show, :edit, :update, :destroy]

  # GET /statuses
  # GET /statuses.json

  def index
    @statuses = Status.order('created_at desc').all

     respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
   
  end

  # GET /statuses/new
  def new
    @status = Status.new
    @status.build_document

    respond_to do |format|
      format.html #new.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/1/edit
  def edit
    @status = current_user.statuses.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = current_user.statuses.new(status_params)

    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: 'Status was successfully created.' }
        format.json { render action: 'show', status: :created, location: @status }
      else
        format.html { render action: 'new' }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statuses/1
  # PATCH/PUT /statuses/1.json
  def update
    @status = current_user.statuses.find(params[:id])
    @document = @status.document
      if status_params && status_params.has_key?(:user_id)
        status_params.delete(:user_id) 
     end
    respond_to do |format|
      if @status.update(status_params) && 
        @document && @document.update_attributes(status_params)
        format.html { redirect_to @status, notice: 'Status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status.destroy
    respond_to do |format|
      format.html { redirect_to statuses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    def set_attachment
      @attachment = @status.document
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_params
      params.require(:status).permit(:content, :profile_name, :full_name, :user_id, :first_name, :last_name, :document_attributes, :attachment, :document, :attachment_file_name, :document_fields, :build_document, :remove_attachment)
    end

    def document_params
      params.require(:attachment).permit(:document_attributes, :attachment, :document, :attachment_file_name, :document_fields, :build_document, :remove_attachment)
    end
end
