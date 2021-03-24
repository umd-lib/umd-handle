# frozen_string_literal: true

# Maps a handle URL to the actual resource URL
class Handle < ApplicationRecord
  around_create :mint_next_suffix
  validate :validate_prefix
  validates :suffix, uniqueness: { scope: :prefix }
  validate :validate_repo

  # Lock for ensuring synchronization in mint_next_suffix
  @@semaphore = Mutex.new # rubocop:disable Style/ClassVars

  def validate_prefix
    errors.add(:prefix, "'#{prefix}' is not a valid prefix") unless Handle.prefixes.include?(prefix)
  end

  def validate_repo
    errors.add(:repo, "'#{repo}' is not a valid repository") unless Handle.repos.include?(repo)
  end

  def self.prefixes
    %w[1903.1]
  end

  def self.repos
    %w[aspace avalon fcrepo fedora2]
  end

  def to_handle_string
    "#{prefix}/#{suffix}"
  end

  private

    # Mints the next suffix, used with "around_create" callback
    def mint_next_suffix
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
