# frozen_string_literal: true

class Handle < ApplicationRecord
  def to_handle_string
    return prefix + '/' + suffix.to_s
  end
end
