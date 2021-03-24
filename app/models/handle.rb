# frozen_string_literal: true

# Maps a handle URL to the actual resource URL
class Handle < ApplicationRecord
  around_create :generate_next_suffix

  # Lock for ensuring synchronization in generate_next_suffix
  @@semaphore = Mutex.new # rubocop:disable Style/ClassVars

  def to_handle_string
    "#{prefix}/#{suffix}"
  end

  private

    # Generates the next suffix, used with "around_create" callback
    def generate_next_suffix
      # Synchronized to ensure that multiple invocations can't get the
      # suffix number
      @@semaphore.synchronize do
        # Determine the current max value for the suffix, scoped to the prefix
        max_value = Handle.group(:prefix).maximum(:suffix)[prefix]

        # max_value will be nil only if this is the first suffix for a prefix
        max_value = 0 if max_value.nil?

        # Set the suffix value for this instance by incrementing the max_value
        self.suffix = max_value + 1

        # Continue with create
        yield
      end
    end
end
