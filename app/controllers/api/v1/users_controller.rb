module Api
  module V1
    class UsersController < ApplicationController
      doorkeeper_for :all
      respond_to :json

      def show
        # puts doorkeeper_token.application.name
        @user = User.includes(:certificates).find(current_user)
        render "api/users/show"
      end

      def show_certificate
        user = User.find(current_user)
        @certificate = Certificate.find(params[:certificate_id])
        render "api/certificates/show"
      end

      def enable_site
        user = User.find(current_user)
        @certificate = Certificate.find(params[:certificate_id])
        external_site = ExternalSite.find_by_name(doorkeeper_token.application.name)
        @certificate.external_sites << external_site
        if @certificate && @certificate.save
          render 'api/certificates/show'
        end
      end

      def deactivate_certificate
        user = User.find(current_user)
        @certificate = Certificate.find(params[:certificate_id])
        @certificate.active = false
        if @certificate && @certificate.save
          render 'api/certificates/show'
        end
      end

      def check_fingerprint
        user = User.find(current_user)
        @certificate = Certificate.find(params[:certificate_id])
        @fingerprint = params[:fingerprint]

        if @fingerprint == @certificate.fingerprint
          render json: { result: 'valid fingerprint' }
        else
          render json: { result: 'invalid fingerprint' }
        end
      end

      private

      def current_user
        @current_user = User.find(session[:user_id]) || User.find(doorkeeper_token.resource_owner_id)
      end
    end
  end
end
