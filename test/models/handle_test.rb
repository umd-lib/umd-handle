# frozen_string_literal: true

require 'test_helper'

# Tests for the Handle model
class HandleTest < ActiveSupport::TestCase
  setup do
    @valid_prefix = Handle.prefixes[0]
    @valid_repo = Handle.repos[0]
  end

  test 'combined prefix and suffix must be unique model validation' do
    # Create will assign a suffix automatically
    handle1 = handles(:one)

    assert_raise(ActiveRecord::RecordInvalid) do
      # Create another handle
      handle2 = Handle.new(prefix: @valid_prefix, repo: @valid_repo)
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
      handle2 = Handle.new(prefix: @valid_prefix, repo: @valid_repo)
      handle2.save!
      # Attempt to set the suffix to the suffix of the other handle, while
      # skipping model validation
      handle2.suffix = handle1.suffix
      handle2.save(validate: false)
    end
  end

  test 'prefix must be a known prefix' do
    handle = Handle.new(prefix: 'INVALID_PREFIX', repo: @valid_repo)
    assert_not handle.valid?
  end

  test 'repo must be a known repository' do
    handle = Handle.new(prefix: @valid_prefix, repo: 'INVALID_REPO')
    assert_not handle.valid?
  end
end
