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

  describe "PATCH /admin/users/:id/toggle_admin" do
    context "when signed in as an admin" do
      before do
        sign_in admin
      end

      it "toggles admin from false to true" do
        expect {
          patch toggle_admin_admin_user_path(regular_user)
        }.to change { regular_user.reload.admin }.from(false).to(true)

        expect(response).to redirect_to(admin_users_path)
        expect(flash[:notice]).to eq("User updated.")
      end

      it "toggles admin from true to false" do
        user = create(:user, admin: true)

        expect {
          patch toggle_admin_admin_user_path(user)
        }.to change { user.reload.admin }.from(true).to(false)

        expect(response).to redirect_to(admin_users_path)
      end
    end

    context "when signed in as a non-admin user" do
      before do
        sign_in regular_user
      end

      it "does not allow access" do
        patch toggle_admin_admin_user_path(regular_user)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when not signed in" do
      it "redirects to the sign-in page" do
        patch toggle_admin_admin_user_path(regular_user)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
