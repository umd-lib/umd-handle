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

      private

        # Only allow a list of trusted parameters through.
        def handle_params
          params.require(:handle).permit(:prefix, :url, :repo, :repo_id, :description, :notes)
        end
    end
  end
end
