# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @q = Handle.ransack(params[:q])
  end
end
