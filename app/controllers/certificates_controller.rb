class CertificatesController < ApplicationController
  load_and_authorize_resource

  before_filter :find_user

  def find_user
    @user = User.find(params[:user_id]) || current_user
  end

  # GET /certificates
  def index
    @certificates = @user.certificates
  end

  # GET /certificates/1
  def show
    @certificate = Certificate.find(params[:id])
  end

  # GET /certificates/new
  def new
    @certificate = Certificate.new
  end

  # GET /certificates/1/edit
  def edit
    @certificate = Certificate.find(params[:id])
  end

  # POST /certificates
  def create
    @certificate = @user.certificates.build(params[:certificate])

    if @certificate.save
      redirect_to [@user, @certificate], 
        notice: 'Certificate was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /certificates/1
  def update
    @certificate = Certificate.find(params[:id])

    if @certificate.update_attributes(params[:certificate])
      redirect_to [@user, @certificate],
        notice: 'Certificate was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /certificates/1
  def destroy
    @certificate = Certificate.find(params[:id])
    @certificate.destroy

    redirect_to user_certificates_url(@user)
  end
end
