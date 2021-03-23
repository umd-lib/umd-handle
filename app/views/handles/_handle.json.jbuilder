# frozen_string_literal: true

json.extract! handle, :id, :prefix, :suffix, :url, :repo, :repo_id, :description, :notes, :created_at, :updated_at
json.url handle_url(handle, format: :json)
