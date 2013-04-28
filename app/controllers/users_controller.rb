require 'tempfile'

class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  def index
    redirect_to root_url
  end

  # GET /users/1
  def show
    @user = User.includes(:certificates).find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /users/1
  def destroy
    # Don't delete users
  end

  # GET /users/1/pair/new
  def new_pair
    @user = User.find(params[:id])
  end

  # POST /users/1/pair
  def create_pair
    @user = User.find(params[:id])
    if validate_pair_parameters
      @pair = @user.generate_pair(
        type: params[:certificate_pair][:type],
        length: params[:certificate_pair][:length].to_i,
        comment: params[:certificate_pair][:comment],
        passphrase: params[:certificate_pair][:passphrase]
      )

      send_data(
        @pair.private_key,
        filename: "id_#{params[:certificate_pair][:type].downcase}.prv",
        type: 'text/plain',
        disposition: 'attachment',
      )

      @user.certificates << Certificate.new(
        nickname: params[:certificate_pair][:comment],
        active: true,
        contents: @pair.ssh_public_key
      )

      @pair = nil
    else
      render 'new_pair'
    end
  end

  def validate_pair_parameters
    errors = []
    cparms = params[:certificate_pair]

    if !cparms
      return false
    end

    [:comment, :type, :length, :passphrase].each do |s|
      if !cparms[s] || cparms[s] == ''
        errors << "A #{s.to_s} is required."
      end
    end

    if cparms[:type] == 'DSA' && cparms[:length] != '1024'
        errors << "DSA pairs can only be 1024 bits long."
    end

    if cparms[:passphrase] != cparms[:passphrase_confirmation]
      errors << "Passphrase and passphrase confirmation must match."
    end

    if cparms[:passphrase] && cparms[:passphrase].length < 4
      errors << "Passphrase must be at least four characters long."
    end

    if errors.count > 0
      flash[:warn] = "Please correct the following errors: "
      errors.each { |e| flash[:warn] << "#{e} " }
      false
    else
      true
    end
  end
end
