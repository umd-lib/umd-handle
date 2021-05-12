# frozen_string_literal: true

require 'test_helper'
require 'rake'

# Tests for "jwt" Rake tasks
class CsvImportTest < ActiveSupport::TestCase
  setup do
    # Load Rake tasks, but only once
    UmdHandle::Application.load_tasks if Rake::Task.tasks.empty?
  end

  test 'csv_import with valid data' do
    assert_difference('Handle.count', 2) do
      assert_output(/Importing handle/) do
        Rake::Task['handle:csv_import'].invoke('test/fixtures/files/valid-handles.csv')
      end
    end
  end

  test 'csv_import with duplicate data' do
    assert_no_difference('Handle.count') do
      assert_output(/already exists/) do
        Rake::Task['handle:csv_import'].invoke('test/fixtures/files/duplicate-handles.csv')
      end
    end
  end

  test 'csv_import with invalid data' do
    assert_no_difference('Handle.count') do
      assert_output(/^Import failed/) do
        Rake::Task['handle:csv_import'].invoke('test/fixtures/files/invalid-handles.csv')
      end
    end
  end

  teardown do
    # Need to renable all Rake tasks run in more than once
    Rake::Task['handle:csv_import'].reenable
  end
end
