# frozen_string_literal: true

# Model logging the JWT tokens that have been issued via the
# "jwt:create_token" Rake task
class JwtTokenLog < ApplicationRecord
  validates :description, presence: true
end
