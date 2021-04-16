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
        respond_with Handle.create(params[:handle])
      end
    end
  end
end
