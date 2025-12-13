# spec/requests/admin/users_request_spec.rb
require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, admin: true) }
  let(:regular_user) { create(:user) }

  describe "GET /admin/users" do
    context "when not signed in" do
      it "redirects to the login page" do
        get admin_users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as non-admin" do
      before { login_as(regular_user, scope: :user) }

      it "returns a forbidden response" do
        get admin_users_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Not authorized")
      end
    end

    context "when signed in as admin" do
      before { login_as(admin, scope: :user) }

      it "returns a success response" do
        get admin_users_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Users")
      end
    end
  end
end
