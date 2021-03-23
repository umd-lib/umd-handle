# frozen_string_literal: true

class HandlesController < ApplicationController
  before_action :set_handle, only: %i[show edit update destroy]

  # GET /handles or /handles.json
  def index
    @q = Handle.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @handles = @q.result.page(params[:page])
  end

  # GET /handles/1 or /handles/1.json
  def show
  end

  # GET /handles/new
  def new
    @handle = Handle.new
  end

  # GET /handles/1/edit
  def edit
  end

  # POST /handles or /handles.json
  def create
    @handle = Handle.new(handle_params)

    respond_to do |format|
      if @handle.save
        format.html { redirect_to @handle, notice: 'Handle was successfully created.' }
        format.json { render :show, status: :created, location: @handle }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @handle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /handles/1 or /handles/1.json
  def update
    respond_to do |format|
      if @handle.update(handle_params)
        format.html { redirect_to @handle, notice: 'Handle was successfully updated.' }
        format.json { render :show, status: :ok, location: @handle }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @handle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /handles/1 or /handles/1.json
  def destroy
    @handle.destroy
    respond_to do |format|
      format.html { redirect_to handles_url, notice: 'Handle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_handle
      @handle = Handle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def handle_params
      params.require(:handle).permit(:prefix, :suffix, :url, :repo, :repo_id, :description, :notes)
    end
end
