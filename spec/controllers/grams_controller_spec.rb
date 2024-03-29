require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should show the new form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should require users to be logged in" do
      post :create, params: { gram: { message: 'Hello!' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should add a gram to the database" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: {
        gram: {
          message: 'Hello!',
          picture: fixture_file_upload("/picture.png", "image/png")
        }
      }
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq('Hello!')
      expect(gram.user).to eq(user)
    end

    it "it should deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
  end

  describe "grams#show action" do
    it "should show the individual gram if a gram is found" do
      gram = FactoryBot.create(:gram)
      get :show, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return 404 if no gram is found" do
      get :show, params: { id: 'FAKEID' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#edit action" do
    it "should only allow the creator to edit the gram" do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthorized users to destroy a gram" do
      gram = FactoryBot.create(:gram)
      get :edit, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the gram is found" do
      gram = FactoryBot.create(:gram)
      sign_in gram.user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the gram is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: 'FAKEID' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#update action" do
    it "should only allow the creator to update the gram" do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: gram.id, gram: { message: 'New message' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthorized users to destroy a gram" do
      gram = FactoryBot.create(:gram)
      patch :update, params: { id: gram.id, gram: { message: 'New message' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to update a gram" do
      gram = FactoryBot.create(:gram, message: 'Initial Message')
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { message: 'Changed' } }
      expect(response).to redirect_to gram_path(gram)
      gram.reload
      expect(gram.message).to eq 'Changed'
    end

    it "should return 404 error if gram is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: 'FAKEID', gram: { message: 'FAKEMESSAGE' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render edit form with unprocessable_entity if not valid" do
      gram = FactoryBot.create(:gram, message: 'Initial Message')
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq 'Initial Message'
    end
  end

  describe "grams#destroy action" do
    it "should only allow creator to destroy a gram" do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthorized users to destroy a gram" do
      gram = FactoryBot.create(:gram)
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy a gram" do
      gram = FactoryBot.create(:gram)
      sign_in gram.user
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to root_path
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end

    it "should return a 404 if a gram is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'FAKEID' }
      expect(response).to have_http_status(:not_found)
    end
  end

end
