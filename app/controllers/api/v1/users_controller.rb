module Api
  module V1
    class UsersController < ApplicationController
      doorkeeper_for :all
      respond_to :json

      def show
        @user = User.includes(:certificates).find(current_user)
        render "api/users/show"
      end

      def show_certificate
        user = User.find(current_user)
        begin
          @certificate = user.certificates.find(params[:certificate_id])
        rescue
        end
        if @certificate
          render "api/certificates/show"
        else
          render nothing: true, status: 401
        end
      end

      def enable_site
        user = User.find(current_user)
        begin
          @certificate = user.certificates.find(params[:certificate_id])
        rescue
        end

        external_site = ExternalSite.find_by_name(doorkeeper_token.application.name)
        unless external_site
          external_site = ExternalSite.create(name: doorkeeper_token.application.name)
        end

        if @certificate
          @certificate.external_sites << external_site
          if @certificate.save
            render 'api/certificates/show'
          end
        else
          render nothing: true, status: 401
        end
      end

      def deactivate_certificate
        user = User.find(current_user)
        @certificate = user.certificates.find(params[:certificate_id])
        @certificate.active = false
        if @certificate && @certificate.save
          render 'api/certificates/show'
        end
      end

      def activate_certificate
        user = User.find(current_user)
        @certificate = user.certificates.find(params[:certificate_id])
        @certificate.active = true
        if @certificate && @certificate.save
          render 'api/certificates/show'
        end
      end

      def check_fingerprint
        user = User.find(current_user)
        @certificate = user.certificates.find(params[:certificate_id])
        @fingerprint = params[:fingerprint]

        if @fingerprint == @certificate.fingerprint
          render json: { result: 'valid fingerprint' }
        else
          render json: { result: 'invalid fingerprint' }
        end
      end

      private

      def current_user
        @current_user ||= User.find(doorkeeper_token.resource_owner_id)
      end
    end
  end
end
