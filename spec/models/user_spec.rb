# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  music_league_user_id   :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_music_league_user_id  (music_league_user_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Music League authorization" do
    let(:authorized_id) { "b1f91a91222d4996b3675463f7e9864c" }
    let(:unauthorized_id) { "00000000000000000000000000000000" }

    before do
      # Stub the credentials to include one authorized ID
      allow(Rails.application.credentials).to receive(:dig)
        .with(:music_league, :authorized_ids)
        .and_return([authorized_id])
      
      # Stub the check for demo user
      allow(Rails.application.credentials).to receive(:dig)
        .with(:demo_user, :music_league_user_id)
        .and_return(nil)
    end

    it "allows creation of a user with an authorized ID" do
      user = User.new(
        email: "authorized@example.com",
        password: "password123",
        password_confirmation: "password123",
        music_league_user_id: authorized_id
      )
      expect(user).to be_valid
    end

    it "prevents creation of a user with an unauthorized ID" do
      user = User.new(
        email: "unauthorized@example.com",
        password: "password123",
        password_confirmation: "password123",
        music_league_user_id: unauthorized_id
      )
      expect(user).not_to be_valid
      expect(user.errors[:music_league_user_id]).to include(
        "is not authorized to create an account."
      )
    end

    it "fails if music_league_user_id is nil" do
      user = User.new(
        email: "no_id@example.com",
        password: "password123",
        password_confirmation: "password123"
      )
      expect(user).not_to be_valid
      expect(user.errors[:music_league_user_id]).to include(
        "can't be blank"
      )
    end
  end
end
