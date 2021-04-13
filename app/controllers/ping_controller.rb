# frozen_string_literal: true

# Controller for network monitoring to use to determine whether the
# application is running.
class PingController < ApplicationController
  skip_before_action :authenticate_user!
  
  def verify
    if application_ok?
      render plain: 'Application is OK'
    else
      render plain: 'Cannot connect to database!', status: :service_unavailable
    end
  end

  # The actual health check to perform
  def application_ok?
    ActiveRecord::Base.connection_pool.with_connection(&:active?)
  end
end
