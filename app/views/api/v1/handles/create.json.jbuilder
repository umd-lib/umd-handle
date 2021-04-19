# frozen_string_literal: true

json.set! :suffix, @handle.suffix.to_s # Force suffix to be a string
json.extract! @handle, :handle_url
json.request do
  json.call(@handle, :prefix, :repo, :repo_id, :url)
end
