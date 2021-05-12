# frozen_string_literal: true

# Force suffix to be returned as a string, instead of an integer, in case we
# ever want to return alphanumeric suffixes
suffix = @handle&.suffix.to_s

json.set! :exists, @exists
json.extract! @handle, :handle_url unless @handle.nil?
json.extract! @handle, :prefix unless @handle.nil?
json.set! :suffix, suffix if suffix.present?
json.extract! @handle, :url unless @handle.nil?
json.request do
  json.set! :repo, @repo
  json.set! :repo_id, @repo_id
end
