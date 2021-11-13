# frozen_string_literal: true

json.extract! @handle, :handle_url
json.request do
  json.call(@handle, :prefix, :repo, :repo_id, :url)
end
