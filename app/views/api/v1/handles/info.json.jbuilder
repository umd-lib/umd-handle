# frozen_string_literal: true

json.set! :exists, @exists
json.extract! @handle, :handle_url unless @handle.nil?
json.extract! @handle, :repo unless @handle.nil?
json.extract! @handle, :repo_id unless @handle.nil?
json.extract! @handle, :url unless @handle.nil?
json.request do
  json.set! :prefix, @prefix
  json.set! :suffix, @suffix
end
