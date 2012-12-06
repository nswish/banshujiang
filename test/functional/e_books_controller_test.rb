require 'test_helper'

class EBooksControllerTest < ActionController::TestCase
  setup do
    @e_book = e_books(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:e_books)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create e_book" do
    assert_difference('EBook.count') do
      post :create, e_book: { author: @e_book.author, download_name: @e_book.download_name, download_url: @e_book.download_url, format: @e_book.format, image_large: @e_book.image_large, image_small: @e_book.image_small, language: @e_book.language, name: @e_book.name, publish_data: @e_book.publish_data, publisher: @e_book.publisher }
    end

    assert_redirected_to e_book_path(assigns(:e_book))
  end

  test "should show e_book" do
    get :show, id: @e_book
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @e_book
    assert_response :success
  end

  test "should update e_book" do
    put :update, id: @e_book, e_book: { author: @e_book.author, download_name: @e_book.download_name, download_url: @e_book.download_url, format: @e_book.format, image_large: @e_book.image_large, image_small: @e_book.image_small, language: @e_book.language, name: @e_book.name, publish_data: @e_book.publish_data, publisher: @e_book.publisher }
    assert_redirected_to e_book_path(assigns(:e_book))
  end

  test "should destroy e_book" do
    assert_difference('EBook.count', -1) do
      delete :destroy, id: @e_book
    end

    assert_redirected_to e_books_path
  end
end
