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
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :league_memberships
  has_many :leagues, through: :league_memberships

  validates :music_league_user_id,
            presence: true,
            format: { with: /\A[a-f0-9]{32}\z/i }

  validate :must_be_authorized_music_league_user, on: :create

  private

  def must_be_authorized_music_league_user
    valid_ids = Rails.application.credentials.dig(:music_league, :authorized_ids) || []

    unless valid_ids.include?(music_league_user_id)
      errors.add(:music_league_user_id, "is not authorized to create an account.")
    end
  end
end
