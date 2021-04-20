# frozen_string_literal: true

# Maps a handle URL to the actual resource URL
class Handle < ApplicationRecord
  around_create :mint_next_suffix
  validate :validate_prefix
  validates :suffix, uniqueness: { scope: :prefix }
  validate :validate_repo
  validates :repo_id, presence: { message: 'is required' }
  validate :validate_url

  # Ransack object to allow "handle" (i.e., "<prefix>/<suffix>") searches
  ransacker :handle do |parent|
    Arel::Nodes::InfixOperation.new(
      '||', Arel::Nodes::InfixOperation.new(
              '||', parent.table[:prefix], Arel::Nodes.build_quoted('/')
            ),
      parent.table[:suffix]
    )
  end

  # Lock for ensuring synchronization in mint_next_suffix
  @@semaphore = Mutex.new # rubocop:disable Style/ClassVars

  def validate_prefix
    # Using this method instead of "presence" and "inclusion" validatons
    # so "Handle.prefixes" does not have to be place above validations in the
    # source code.
    errors.add(:prefix, 'is required') and return if prefix.nil?

    errors.add(:prefix, "'#{prefix}' is not a valid prefix") unless Handle.prefixes.include?(prefix)
  end

  def validate_repo
    # Using this method instead of "presence" and "inclusion" validatons
    # so "Handle.prefixes" does not have to be place above validations in the
    # source code.
    errors.add(:repo, 'is required') and return if repo.nil?

    errors.add(:repo, "'#{repo}' is not a valid repository") unless Handle.repos.include?(repo)
  end

  def validate_url
    errors.add(:url, 'is required') and return if url.nil?

    valid = false
    begin
      uri = URI.parse(url)
      valid = uri.is_a?(URI::HTTP) && uri.host.present?
    rescue URI::InvalidURIError
      valid = false
    end

    errors.add(:url, "'#{url}' is not a valid URL") unless valid
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

  # Returns the fully-qualified URL to use as the handle URL
  def handle_url
    "#{Rails.application.config.handle_http_proxy_base}#{prefix}/#{suffix}"
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
