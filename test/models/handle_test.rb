# frozen_string_literal: true

require 'test_helper'

# Tests for the Handle model
class HandleTest < ActiveSupport::TestCase
  setup do
    valid_prefix = Handle.prefixes[0]
    valid_repo = Handle.repos[0]
    valid_repo_id = 'test'
    valid_url = 'http://example.com/test'

    @valid_handle = Handle.new(
      prefix: valid_prefix, repo: valid_repo, repo_id: valid_repo_id,
      url: valid_url
    )
  end

  test 'combined prefix and suffix must be unique model validation' do
    # Create will assign a suffix automatically
    handle1 = handles(:one)

    assert_raise(ActiveRecord::RecordInvalid) do
      # Create another handle
      handle2 = @valid_handle
      handle2.save!
      # Attempt to set the suffix to the suffix of the other handle, while
      # skipping model validation
      handle2.suffix = handle1.suffix
      assert_not handle2.valid?
      handle2.save!
    end
  end

  test 'combined prefix and suffix must be unique database constraint' do
    # Create will assign a suffix automatically
    handle1 = handles(:one)

    assert_raise(ActiveRecord::RecordNotUnique) do
      # Create another handle
      handle2 = @valid_handle
      handle2.save!
      # Attempt to set the suffix to the suffix of the other handle, while
      # skipping model validation
      handle2.suffix = handle1.suffix
      handle2.save(validate: false)
    end
  end

  test 'prefix must be a known prefix' do
    handle = @valid_handle
    handle.prefix = 'INVALID_PREFIX'
    assert_not handle.valid?
  end

  test 'repo must be a known repository' do
    handle = @valid_handle
    handle.repo = 'INVALID_REPO'
    assert_not handle.valid?
  end

  test 'repo_id must be present' do
    handle = @valid_handle
    handle.repo_id = ''
    assert_not handle.valid?
  end

  test 'invalid URLs are not allowed' do
    invalid_urls = [
      '',
      ' ',
      'abcd',
      'http123',
      'ftp://lib.umd.edu'
    ]

    invalid_urls.each do |url|
      handle = @valid_handle
      handle.url = url
      assert_not handle.valid?, "'#{url}' was accepted as a valid url"
    end
  end

  test 'valid URLs are allowed' do
    valid_urls = [
      'http://drum.lib.umd.edu/handle/1903/413',
      'http://drum.lib.umd.edu/handle/1903/413',
      'http://example.com/'
    ]

    valid_urls.each do |url|
      handle = @valid_handle
      handle.url = url
      assert handle.valid?, "'#{url}' was not accepted as a valid url"
    end
  end
end
