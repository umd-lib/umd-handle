# frozen_string_literal: true

require 'application_system_test_case'

# Integration tests for handles
class HandlesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @handle = handles(:one)
    sign_in users(:one)
  end

  test 'visiting the index' do
    visit handles_url
    assert_selector '.h1', text: 'Handles'
  end

  test 'creating a Handle' do
    prefix_to_select = Handle.prefixes[0]
    repo_to_select = Handle.repos[0]

    visit handles_url
    click_on 'New Handle'

    fill_in 'Description', with: @handle.description
    fill_in 'Notes', with: @handle.notes
    select prefix_to_select, from: 'Prefix'
    select repo_to_select, from: 'Repository'
    fill_in 'Repository Id', with: @handle.repo_id
    fill_in 'Url', with: @handle.url
    click_on 'Create Handle'

    assert_text 'Handle was successfully created'
  end

  test 'updating a Handle' do
    visit handles_url
    click_on 'Edit', match: :first

    fill_in 'Description', with: @handle.description
    fill_in 'Notes', with: @handle.notes
    fill_in 'Repository', with: @handle.repo
    fill_in 'Repository Id', with: @handle.repo_id
    fill_in 'Url', with: @handle.url
    click_on 'Update Handle'

    assert_text 'Handle was successfully updated'
  end

  test 'destroying a Handle' do
    visit handles_url
    page.accept_confirm do
      click_on 'Delete', match: :first
    end

    assert_text 'Handle was successfully destroyed'
  end
end
