# frozen_string_literal: true

module Api
  module V1
    # Handles controller for the REST API
    class HandlesController < Api::ApiController
      respond_to :json

      def show
        @handle = Handle.find_by(suffix: params[:suffix], prefix: params[:prefix])
        render json: {}, status: :not_found if @handle.nil?
      end

      def create
        @handle = Handle.new(handle_params)

        render json: { errors: @handle.errors.full_messages }, status: :bad_request unless @handle.save
      end

      # PATCH /handles/prefix/suffix
      def update
        @handle = Handle.find_by(suffix: params[:suffix], prefix: params[:prefix])
        Rails.logger.info("Updating handle #{@handle}, is nil? #{@handle.nil?}")
        if @handle.nil?
          render json: {}, status: :not_found
        else
          @handle.update(handle_update_params)
          render json: { errors: @handle.errors.full_messages }, status: :bad_request unless @handle.save
        end
      end

      def exists
        @repo = params[:repo]
        @repo_id = params[:repo_id]

        @errors = []
        @errors << '"repo" is required' if @repo.blank?
        @errors << '"repo_id" is required' if @repo_id.blank?
        render json: { errors: @errors },  status: :bad_request and return unless @errors.empty?

        @handle = Handle.find_by repo: @repo, repo_id: @repo_id
        @exists = !@handle.nil?
      end

      def info
        @prefix = params[:prefix]
        @suffix = params[:suffix]

        @errors = []
        @errors << '"prefix" is required' if @prefix.blank?
        @errors << '"suffix" is required' if @suffix.blank?
        render json: { errors: @errors }, status: :bad_request and return unless @errors.empty?

        @handle = Handle.find_by prefix: @prefix, suffix: @suffix
        @exists = !@handle.nil?
      end

      private

        # Only allow a list of trusted parameters through.
        def handle_params
          params.require(:handle).permit(:prefix, :url, :repo, :repo_id, :description, :notes)
        end

        # Only allow a list of trusted parameters through.
        def handle_update_params
          params.require(%i[prefix suffix])
          params.permit(:url, :repo, :repo_id, :description, :notes)
        end
    end
  end
end
