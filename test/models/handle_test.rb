# frozen_string_literal: true

require 'test_helper'

# Tests for the Handle model
class HandleTest < ActiveSupport::TestCase
  test 'combined prefix and suffix must be unique model validation' do
    # Create will assign a suffix automatically
    handle1 = Handle.new(prefix: 'TEST')
    handle1.save!
    # Reset the suffix to a known value
    handle1.suffix = 1
    assert handle1.valid?
    handle1.save!

    assert_raise(ActiveRecord::RecordInvalid) do
      # Create another handle
      handle2 = Handle.new(prefix: 'TEST')
      handle2.save!
      # Attempt to set the suffix to the suffix of the other handle, while
      # skipping model validation
      handle2.suffix = 1
      assert_not handle2.valid?
      handle2.save!
    end
  end

  test 'combined prefix and suffix must be unique database constraint' do
    # Create will assign a suffix automatically
    handle1 = Handle.new(prefix: 'TEST')
    handle1.save!
    # Reset the suffix to a known value
    handle1.suffix = 1
    handle1.save!

    assert_raise(ActiveRecord::RecordNotUnique) do
      # Create another handle
      handle2 = Handle.new(prefix: 'TEST')
      handle2.save!
      # Attempt to set the suffix to the suffix of the other handle, while
      # skipping model validation
      handle2.suffix = 1
      handle2.save(validate: false)
    end
  end
end
