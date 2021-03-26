# frozen_string_literal: true

require 'test_helper'

class HandlesControllerTest < ActionController::TestCase
  test 'index -  search panel not expanded when there are no query params' do
    get :index
    assert_equal false, assigns(:expand_sort_form)
  end

  test 'index - search panel expanded when search query params exist' do
    get :index, params: { q: { repo_cont: 'fcrepo' } }
    assert_equal true, assigns(:expand_sort_form)
  end

  test 'index -  search panel not expanded when there is only a sort query parameter' do
    get :index, params: { q: { s: 'url asc' } }
    assert_equal false, assigns(:expand_sort_form)
  end

  test 'index - show no handles message when no handles displayed' do
    get :index, params: { q: { repo_cont: 'NON-EXISTENT_REPO' } }

    # The search should return no results
    handles = assigns(:handles)
    assert handles.count.zero?

    assert assigns(:show_no_handles_found)
  end

  test 'index - show no handles message now shown when handles displayed' do
    get :index

    # The search should have at least one result
    handles = assigns(:handles)
    assert_not handles.count.zero?

    assert_not assigns(:show_no_handles_found)
  end
end
