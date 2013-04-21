module Api
  module V1
    class UsersController < ApplicationController
      respond_to :json

      def show
        @user = User.includes(:certificates).find_by_username(params[:username])
        render "api/users/show"
      end

      def show_certificate
        user = User.find_by_username(params[:username])
        @certificate = Certificate.find(params[:certificate_id])
        render "api/certificates/show"
      end
    end
  end
end
